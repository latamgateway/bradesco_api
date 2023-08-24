require "json"

module BradescoApi
  module Entity
    module Pix
      class Charge
        extend T::Sig

        sig { returns(BradescoApi::Entity::Pix::Attributes::Calendar) }
        attr_accessor :calendar

        sig { returns(BradescoApi::Entity::Pix::Attributes::Locale) }
        attr_accessor :locale

        sig { returns(BradescoApi::Entity::Pix::Attributes::Customer) }
        attr_accessor :customer

        sig { returns(BradescoApi::Entity::Pix::Attributes::Value) }
        attr_accessor :value

        sig { returns(T.nilable(BradescoApi::Entity::Pix::Attributes::AdditionalInformation)) }
        attr_accessor :additional_information

        sig { returns(String) }
        attr_accessor :free_text, :qr_code_text, :identifier

        sig do
          params(
            identifier: String,
            customer: BradescoApi::Entity::Pix::Attributes::Customer,
            value: BradescoApi::Entity::Pix::Attributes::Value,
            free_text: String,
            qr_code_text: String,
            locale: BradescoApi::Entity::Pix::Attributes::Locale,
            calendar: BradescoApi::Entity::Pix::Attributes::Calendar,
            additional_information: T.nilable(BradescoApi::Entity::Pix::Attributes::AdditionalInformation)
          ).void
        end
        def initialize(
          identifier:,
          customer:,
          value:,
          free_text: '',
          qr_code_text: '',
          locale: nil,
          calendar: nil,
          additional_information: nil
        )
          @identifier = identifier
          @calendar = calendar
          @locale = locale
          @customer = customer
          @value = value
          @free_text = free_text
          @qr_code_text = qr_code_text
          @additional_information = additional_information
        end

        sig { returns(String) }
        def serialize

          payer = {
            nome: @customer.name
          }

          payer_document_key = @customer.document.length > 11 ? "cnpj" : "cpf"
          payer[payer_document_key] = @customer.document

          payer[:logradouro] = @customer.address unless @customer.address.empty?
          payer[:cidade] = @customer.city unless @customer.city.empty?
          payer[:uf] = @customer.state unless @customer.state.empty?
          payer[:cep] = @customer.zip_code unless @customer.zip_code.empty?

          payload = {
            "calendario": {
              "dataDeVencimento": @calendar.due_date,
              "validadeAposVencimento": @calendar.limit_after_due_date
            },
            "devedor": payer,
            "valor": {
              "original": @value.original,
            },
            "chave": ENV['BRADESCO_PIX_KEY'],
            "solicitacaoPagador": @free_text
          }

          payload[:valor]["multa"] = common_value_attrs(@value.fine_for_delay) unless @value.fine_for_delay.nil?
          payload[:valor]["juros"] = common_value_attrs(@value.tax) unless @value.tax.nil?
          payload[:valor]["abatimento"] = common_value_attrs(@value.reduction) unless @value.reduction.nil?

          unless @value.discount.nil?
            discount = {
              "modalidade": @value.discount.modality,
              "valorPerc": @value.discount.percentage_value
            }

            fixed_dates = []
            unless @value.discount.fixed_date_discount.empty?
              @value.discount.fixed_date_discount.each do |f|
                fixed_dates << {
                  "data": f.date,
                  "valorPerc": f.percentage_value
                }
              end
            end

            discount.delete(:valorPerc) if is_modality_by_date?(@value.discount.modality)

            payload[:valor]["desconto"] = {
              **discount,
              "descontoDataFixa": is_modality_by_date?(@value.discount.modality) ? fixed_dates : []
            }
          end

          unless @qr_code_text.empty?
            payload["nomePersonalizacaoQr"] = @qr_code_text
          end

          JSON.dump(payload)
        end

        protected

        sig do
          params(modality: Integer).returns(T::Boolean)
        end
        def is_modality_by_date?(modality)
          [1, 2].include?(modality)
        end

        private

        sig do
          params(common_value: BradescoApi::Entity::Pix::Attributes::CommonFieldsValue)
            .returns(T::Hash[Symbol, T.untyped])
        end
        def common_value_attrs(common_value)
          {
            "modalidade": common_value.modality,
            "valorPerc": common_value.percentage_value
          }
        end
      end
    end
  end
end
