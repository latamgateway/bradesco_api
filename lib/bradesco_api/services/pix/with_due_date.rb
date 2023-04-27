require "base64"
require "json"

module BradescoApi
  module Services
    module Pix
      class WithDueDate
        extend T::Sig

        sig { returns(BradescoApi::Entity::Pix::WithDueDate) }
        attr_accessor :billing

        sig { returns(BradescoApi::Entity::Security::SSLConfig) }
        attr_accessor :ssl_config

        sig { returns(BradescoApi::Entity::Security::Credentials) }
        attr_accessor :credentials

        sig do
          params(
            billing: BradescoApi::Entity::Pix::WithDueDate,
            credentials: BradescoApi::Entity::Security::Credentials,
            ssl_config: BradescoApi::Entity::Security::SSLConfig
          ).void
        end

        def initialize(billing:, credentials:, ssl_config:)
          @billing = billing
          @credentials = credentials
          @ssl_config = ssl_config
        end

        sig do
          params(identifier: String)
            .returns(T.any(BradescoApi::Entity::Pix::WithDueDateResponse, BradescoApi::Entity::Errors::ResponseApi))
        end
        def create(identifier)

          st = BradescoApi::Services::System::Token.new(
            ssl_config: @ssl_config,
            credentials: @credentials
          )
          token = st.create

          headers = {
            'Authorization': "Bearer #{token.access_token}",
            'Content-Type': 'application/json'
          }

          uri = "https://qrpix-h.bradesco.com.br/v2/cobv/#{identifier}"

          http = BradescoApi::Utils::HTTP.new(@ssl_config)
          response = http.put(
            uri: uri,
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
              # "abatimento": {
              #   "modalidade": billing.value.reduction.modality,
              #   "valorPerc": billing.value.reduction.percentage_value
              # },
              # "desconto": {
              #   "modalidade": billing.value.discount.modality,
              #   "descontoDataFixa": billing.value.discount.fixed_date_discount
              # }
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

          unless billing.reduction.nil?
            body[:valor]["abatimento"] = {
              "modalidade": billing.value.reduction.modality,
              "valorPerc": billing.reduction.percentage_value
            }
          end

          unless billing.discount.nil?
            body[:valor]["desconto"] = {
              "modalidade": billing.value.reduction.modality,
              "valorPerc": billing.reduction.percentage_value
            }
            unless billing.discount.fixed_date_discount.empty?
              body[:valor]["desconto"]["descontoDataFixa"] = billing.discount.fixed_date_discount
            end
          end


          puts body

          body
        end

        sig do
          params(payload: String)
            .returns(BradescoApi::Entity::Pix::WithDueDateResponse)
        end
        def deserialize_response(payload)
          data = JSON.parse(payload)

          puts data

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

          BradescoApi::Entity::Pix::WithDueDateResponse.new(
            customer: customer,
            value: value,
            seller: seller,
            pix_key: data['chave'],
            status: data['status'],
            identifier: data['txid'],
            emv: data['pixCopiaECola'] || data['emv'],
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