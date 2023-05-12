module BradescoApi
  module Entity
    module Pix
      class ChargeResponse < BradescoApi::Entity::Pix::Charge
        extend T::Sig

        sig { returns(Integer) }
        attr_accessor :revision

        sig { returns(String) }
        attr_accessor :status, :emv, :free_text, :base64

        sig { returns(BradescoApi::Entity::Pix::Attributes::Seller) }
        attr_accessor :seller

        sig do
          params(
            payload: String,
          ).void
        end
        def initialize(payload)
          data = JSON.parse(payload)
          
          data = data['cobv'] if data.include?('cobv')

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
            if is_modality_by_date?(data['valor']['desconto']['modalidade'])
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

          super(
            identifier: data['txid'],
            customer: customer,
            value: value,
            pix_key: data['chave'],
            free_text: data['solicitacaoPagador'],
            locale: locale,
            calendar: calendar
          )

          @revision = data['revisao']
          @status = data['status']
          @emv = data['emv']
          @base64 = data['base64']
          @seller = seller

        end

        def serialize
          raise NoMethodError
        end
      end
    end
  end
end