require "base64"
require "json"

module BradescoApi
  module Services
    module Pix
      class WithDueDate
        extend T::Sig

        sig { returns(BradescoApi::Entity::Pix::WithDueDate) }
        attr_accessor :billing

        sig do
          params(
            billing: BradescoApi::Entity::Pix::WithDueDate,
            with_qr_code: T::Boolean
          ).void
        end

        def initialize(billing:, with_qr_code: false)
          @billing = billing
          @with_qr_code = with_qr_code
        end

        sig do
          params(identifier: String)
            .returns(T.any(BradescoApi::Entity::Pix::WithDueDateResponse, BradescoApi::Entity::Errors::ResponseApi))
        end
        def create(identifier)

          st = BradescoApi::Services::System::Token.new()
          token = st.create

          headers = {
            'Authorization': "Bearer #{token.access_token}",
            'Content-Type': 'application/json'
          }

          endpoint = "/v2/cobv/#{identifier}"
          if @with_qr_code
            endpoint = "/v2/cobv-emv/#{identifier}"
          end

          http = BradescoApi::Utils::HTTP.new()
          response = http.put(
            endpoint: endpoint,
            payload: JSON.dump(serialize_body(billing)),
            headers: headers
          )

          if response.code.to_i == 200
            return deserialize_response(response.read_body)
          end

          serialize_error(response.read_body)
        end

        private

        sig do
          params(billing: BradescoApi::Entity::Pix::WithDueDate)
            .returns(T::Hash[Symbol, T.untyped])
        end
        def serialize_body(billing)
          body = {
            "calendario": {
              "dataDeVencimento": billing.calendar.due_date,
              "validadeAposVencimento": billing.calendar.limit_after_due_date
            },
            "devedor": {
              "logradouro": billing.customer.address,
              "cidade": billing.customer.city,
              "uf": billing.customer.state,
              "cep": billing.customer.zip_code,
              "cpf": billing.customer.document,
              "nome": billing.customer.name
            },
            "valor": {
              "original": billing.value.original,
            },
            "chave": billing.pix_key,
            "solicitacaoPagador": billing.free_text
          }

          unless billing.value.fine_for_delay.nil?
            fine_for_delay = {
              "modalidade": billing.value.fine_for_delay.modality,
              "valorPerc": billing.value.fine_for_delay.percentage_value
            }

            value = body[:valor]
            value["multa"] = fine_for_delay
            body[:valor] = value
          end

          unless billing.value.tax.nil?
            tax = {
              "modalidade": billing.value.tax.modality,
              "valorPerc": billing.value.tax.percentage_value
            }

            value = body[:valor]
            value["juros"] = tax
            body[:valor] = value
          end

          unless billing.value.reduction.nil?
            body[:valor]["abatimento"] = {
              "modalidade": billing.value.reduction.modality,
              "valorPerc": billing.value.reduction.percentage_value
            }
          end

          unless billing.value.discount.nil?
            discount = {
              "modalidade": billing.value.discount.modality,
              "valorPerc": billing.value.discount.percentage_value
            }

            fixed_dates = []
            unless billing.value.discount.fixed_date_discount.empty?
              billing.value.discount.fixed_date_discount.each do |f|
                fixed_dates << {
                  "data": f.date,
                  "valorPerc": f.percentage_value
                }
              end
            end

            discount.delete(:valorPerc) if is_modality_by_date?(billing.value.discount.modality)

            body[:valor]["desconto"] = {
              **discount,
              "descontoDataFixa": is_modality_by_date?(billing.value.discount.modality) ? fixed_dates : []
            }
          end

          if @with_qr_code
            body["nomePersonalizacaoQr"] = billing.qr_code_text
          end

          puts body

          body
        end

        def is_modality_by_date?(modality)
          [1, 2].include?(modality)
        end

        def common_value_attrs(obj)
          {
            "modalidade": obj[:modality],
            "valorPerc": obj[:percentage]
          }
        end

        sig do
          params(payload: String)
            .returns(BradescoApi::Entity::Pix::WithDueDateResponse)
        end
        def deserialize_response(payload)
          data = JSON.parse(payload)

          if @with_qr_code
            data['cobv']['emv'] = data['emv']
            data['cobv']['base64'] = data['base64']
            data = data['cobv']
          end

          calendar = BradescoApi::Entity::Pix::Attributes::Calendar.new(
            due_date: data['calendario']['dataDeVencimento'],
            limit_after_due_date: data['calendario']['validadeAposVencimento'],
            creation: data['calendario']['criacao'],
          )

          customer = BradescoApi::Entity::Pix::Attributes::Customer.new(
            document: data['devedor']['cpf'] || data['devedor']['cnpj'] || '',
            name: data['devedor']['nome'],
            address: data['devedor']['logradouro'],
            city: data['devedor']['cidade'],
            state: data['devedor']['uf'],
            zip_code: data['devedor']['cep'],
            email: data['devedor']['email'] || '',
          )

          seller = BradescoApi::Entity::Pix::Attributes::Seller.new(
            document: data['recebedor']['cpf'] || data['recebedor']['cnpj'] || '',
            name: data['recebedor']['nome'],
            address: data['recebedor']['logradouro'],
            city: data['recebedor']['cidade'],
            state: data['recebedor']['uf'],
            zip_code: data['recebedor']['cep'],
            email: data['recebedor']['email'] || '',
          )

          locale = BradescoApi::Entity::Pix::Attributes::Locale.new(
            id: data['loc']['id'],
            type: data['loc']['tipoCob'],
            location: data['loc']['location'],
            creation: data['loc']['criacao'],
          )

          value = BradescoApi::Entity::Pix::Attributes::Value.new(
            original: data['valor']['original'],
          )

          if data['valor'].include?('multa')
            value.fine_for_delay = BradescoApi::Entity::Pix::Attributes::FineForDelay.new(
              modality: data['valor']['multa']['modalidade'],
              percentage_value: data['valor']['multa']['valorPerc']
            )
          end

          if data['valor'].include?('juros')
            value.tax = BradescoApi::Entity::Pix::Attributes::Tax.new(
              modality: data['valor']['juros']['modalidade'],
              percentage_value: data['valor']['juros']['valorPerc']
            )
          end

          if data['valor'].include?('abatimento')
            value.reduction = BradescoApi::Entity::Pix::Attributes::Reduction.new(
              modality: data['valor']['abatimento']['modalidade'],
              percentage_value: data['valor']['abatimento']['valorPerc']
            )
          end

          if data['valor'].include?('desconto')
            if [1, 2].include?(data['valor']['desconto']['modalidade'])
              fixed_date_arr = []
              data['valor']['desconto']['descontoDataFixa'].each do |c|
                fixed_date_arr << BradescoApi::Entity::Pix::Attributes::FixedDateDiscount.new(
                  date: c['data'],
                  percentage_value: c['valorPerc'] 
                )
              end
              puts fixed_date_arr.inspect

              value.discount = BradescoApi::Entity::Pix::Attributes::Discount.new(
                modality: data['valor']['desconto']['modalidade'],
                fixed_date_discount: fixed_date_arr 
              )
            else
              value.discount = BradescoApi::Entity::Pix::Attributes::Discount.new(
                modality: data['valor']['desconto']['modalidade'],
                percentage_value: data['valor']['desconto']['valorPerc']
              )
            end
          end

          
          BradescoApi::Entity::Pix::WithDueDateResponse.new(
            customer: customer,
            value: value,
            seller: seller,
            pix_key: data['chave'],
            status: data['status'],
            identifier: data['txid'],
            emv: data['pixCopiaECola'] || data['emv'],
            base64: data['base64'] || '',
            free_text: data['solicitacaoPagador'],
            revision: data['revisao'],
            locale: locale,
            calendar: calendar,
            additional_information: nil
          )
        end


        sig do
          params(payload: String)
            .returns(BradescoApi::Entity::Errors::ResponseApi)
        end
        def serialize_error(payload)
          puts "---------------------------------"
          puts payload
          puts "---------------------------------"
          data = JSON.parse(payload)

          falts = []
          if data.has_key?('violacoes')
            data['violacoes'].each do |falt|
              d = BradescoApi::Entity::Errors::Falt.new(
                reason: falt['razao'],
                property: falt['propriedade'],
                value: falt['valor'],
              )

              falts << d
            end
          end

          BradescoApi::Entity::Errors::ResponseApi.new(
            status: data['status'].to_s || '500',
            type: data['type'],
            title: data['title'],
            falts: falts,
            related_id: data['correlationId'] || '',
          )
        end
      end
    end
  end
end
