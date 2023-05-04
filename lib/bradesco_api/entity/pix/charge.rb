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

        sig { returns(BradescoApi::Entity::Pix::Attributes::AdditionalInformation) }
        attr_accessor :additional_information

        sig { returns(String) }
        attr_accessor :pix_key, :free_text, :qr_code_text, :identifier

        sig do
          params(
            identifier: String,
            customer: BradescoApi::Entity::Pix::Attributes::Customer,
            value: BradescoApi::Entity::Pix::Attributes::Value,
            pix_key: String,
            free_text: String,
            qr_code_text: String,
            locale: BradescoApi::Entity::Pix::Attributes::Locale,
            calendar: BradescoApi::Entity::Pix::Attributes::Calendar,
            additional_information: BradescoApi::Entity::Pix::Attributes::AdditionalInformation
          ).void
        end
        def initialize(
          identifier:,
          customer:,
          value:,
          pix_key:,
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
          @pix_key = pix_key
          @free_text = free_text
          @qr_code_text = qr_code_text
          @additional_information = additional_information
        end

        def serialize
          body = {
            "calendario": {
              "dataDeVencimento": @calendar.due_date,
              "validadeAposVencimento": @calendar.limit_after_due_date
            },
            "devedor": {
              "logradouro": @customer.address,
              "cidade": @customer.city,
              "uf": @customer.state,
              "cep": @customer.zip_code,
              "cpf": @customer.document,
              "nome": @customer.name
            },
            "valor": {
              "original": @value.original,
            },
            "chave": @pix_key,
            "solicitacaoPagador": @free_text
          }

          unless @value.fine_for_delay.nil?
            fine_for_delay = {
              "modalidade": @value.fine_for_delay.modality,
              "valorPerc": @value.fine_for_delay.percentage_value
            }

            value = body[:valor]
            value["multa"] = fine_for_delay
            body[:valor] = value
          end

          unless @value.tax.nil?
            tax = {
              "modalidade": @value.tax.modality,
              "valorPerc": @value.tax.percentage_value
            }

            value = body[:valor]
            value["juros"] = tax
            body[:valor] = value
          end

          unless @value.reduction.nil?
            body[:valor]["abatimento"] = {
              "modalidade": @value.reduction.modality,
              "valorPerc": @value.reduction.percentage_value
            }
          end

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

            body[:valor]["desconto"] = {
              **discount,
              "descontoDataFixa": is_modality_by_date?(@value.discount.modality) ? fixed_dates : []
            }
          end

          unless @qr_code_text.empty?
            body["nomePersonalizacaoQr"] = @qr_code_text
          end

          JSON.dump(body)
        end

        private

        def is_modality_by_date?(modality)
          [1, 2].include?(modality)
        end

        def common_value_attrs(obj)
          {
            "modalidade": obj[:modality],
            "valorPerc": obj[:percentage]
          }
        end

      end
    end
  end
end