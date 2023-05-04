module BradescoApi
  module Entity
    module Pix
      class WithDueDate
        extend T::Sig

        sig { returns(BradescoApi::Entity::Pix::Attributes::Calendar) }
        attr_accessor :calendar

        sig { returns(BradescoApi::Entity::Pix::Attributes::Locale) }
        attr_accessor :locale

        sig { returns(BradescoApi::Entity::Pix::Attributes::Customer) }
        attr_accessor :customer

        sig { returns(BradescoApi::Entity::Pix::Attributes::Value) }
        attr_accessor :value

        sig { returns(T::Array[BradescoApi::Entity::Pix::Attributes::AdditionalInformation]) }
        attr_accessor :additional_information

        sig { returns(String) }
        attr_accessor :pix_key, :free_text, :qr_code_text

        sig do
          params(
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
          customer:,
          value:,
          pix_key:,
          free_text: '',
          qr_code_text: '',
          locale: nil,
          calendar: nil,
          additional_information: nil
        )
          @calendar = calendar
          @locale = locale
          @customer = customer
          @value = value
          @pix_key = pix_key
          @free_text = free_text
          @qr_code_text = qr_code_text
          @additional_information = additional_information
        end
      end
    end
  end
end