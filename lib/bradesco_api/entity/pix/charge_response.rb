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

          calendar = BradescoApi::Entity::Pix::Attributes::Calendar.new(
            due_date: data['cobv']['calendario']['dataDeVencimento'],
            limit_after_due_date: data['cobv']['calendario']['validadeAposVencimento'],
            creation: data['cobv']['calendario']['criacao'],
          )

          customer = BradescoApi::Entity::Pix::Attributes::Customer.new(
            document: data['cobv']['devedor']['cpf'] || data['cobv']['devedor']['cnpj'] || '',
            name: data['cobv']['devedor']['nome'],
            address: data['cobv']['devedor']['logradouro'],
            city: data['cobv']['devedor']['cidade'],
            state: data['cobv']['devedor']['uf'],
            zip_code: data['cobv']['devedor']['cep'],
            email: data['cobv']['devedor']['email'] || '',
          )

          seller = BradescoApi::Entity::Pix::Attributes::Seller.new(
            document: data['cobv']['recebedor']['cpf'] || data['cobv']['recebedor']['cnpj'] || '',
            name: data['cobv']['recebedor']['nome'],
            address: data['cobv']['recebedor']['logradouro'],
            city: data['cobv']['recebedor']['cidade'],
            state: data['cobv']['recebedor']['uf'],
            zip_code: data['cobv']['recebedor']['cep'],
            email: data['cobv']['recebedor']['email'] || '',
          )

          locale = BradescoApi::Entity::Pix::Attributes::Locale.new(
            id: data['cobv']['loc']['id'],
            type: data['cobv']['loc']['tipoCob'],
            location: data['cobv']['loc']['location'],
            creation: data['cobv']['loc']['criacao'],
            )

          value = BradescoApi::Entity::Pix::Attributes::Value.new(
            original: data['cobv']['valor']['original'],
            )

          if data['cobv']['valor'].include?('multa')
            value.fine_for_delay = BradescoApi::Entity::Pix::Attributes::FineForDelay.new(
              modality: data['cobv']['valor']['multa']['modalidade'],
              percentage_value: data['cobv']['valor']['multa']['valorPerc']
            )
          end

          if data['cobv']['valor'].include?('juros')
            value.tax = BradescoApi::Entity::Pix::Attributes::Tax.new(
              modality: data['cobv']['valor']['juros']['modalidade'],
              percentage_value: data['cobv']['valor']['juros']['valorPerc']
            )
          end

          if data['cobv']['valor'].include?('abatimento')
            value.reduction = BradescoApi::Entity::Pix::Attributes::Reduction.new(
              modality: data['cobv']['valor']['abatimento']['modalidade'],
              percentage_value: data['cobv']['valor']['abatimento']['valorPerc']
            )
          end

          if data['cobv']['valor'].include?('desconto')
            if is_modality_by_date?(data['cobv']['valor']['desconto']['modalidade'])
              fixed_date_arr = []
              data['cobv']['valor']['desconto']['descontoDataFixa'].each do |c|
                fixed_date_arr << BradescoApi::Entity::Pix::Attributes::FixedDateDiscount.new(
                  date: c['data'],
                  percentage_value: c['valorPerc']
                )
              end

              value.discount = BradescoApi::Entity::Pix::Attributes::Discount.new(
                modality: data['cobv']['valor']['desconto']['modalidade'],
                fixed_date_discount: fixed_date_arr
              )
            else
              value.discount = BradescoApi::Entity::Pix::Attributes::Discount.new(
                modality: data['cobv']['valor']['desconto']['modalidade'],
                percentage_value: data['cobv']['valor']['desconto']['valorPerc']
              )
            end
          end

          super(
            identifier: data['cobv']['txid'],
            customer: customer,
            value: value,
            free_text: data['cobv']['solicitacaoPagador'],
            locale: locale,
            calendar: calendar
          )

          @revision = data['cobv']['revisao']
          @status = data['cobv']['status']
          @emv = data['cobv']['emv']
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
