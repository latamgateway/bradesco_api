module BradescoApi
  module Entity
    module Pix
      class WithDueDateResponse < BradescoApi::Entity::Pix::WithDueDate
        extend T::Sig

        sig { returns(Integer) }
        attr_accessor :revision

        sig { returns(String) }
        attr_accessor :status, :identifier, :pix_copy_paste, :free_text

        sig { returns(BradescoApi::Entity::Pix::Attributes::Seller) }
        attr_accessor :seller

        sig do
          params(
            customer: BradescoApi::Entity::Pix::Attributes::Customer,
            value: BradescoApi::Entity::Pix::Attributes::Value,
            seller: BradescoApi::Entity::Pix::Attributes::Seller,
            pix_key: String,
            status: String,
            identifier: String,
            pix_copy_paste: String,
            free_text: String,
            revision: Integer,
            locale: T.nilable(BradescoApi::Entity::Pix::Attributes::Locale),
            calendar: T.nilable(BradescoApi::Entity::Pix::Attributes::Calendar),
            additional_information: T.nilable(BradescoApi::Entity::Pix::Attributes::AdditionalInformation)
          ).void
        end
        def initialize(
          customer:,
          value:,
          seller:,
          pix_key:,
          status:,
          identifier:,
          pix_copy_paste:,
          free_text: '',
          revision: 0,
          locale: nil,
          calendar: nil,
          additional_information: nil
        )
          @customer = customer
          @value = value
          @seller = seller
          @pix_key = pix_key
          @status = status
          @identifier = identifier
          @pix_copy_paste = pix_copy_paste
          @free_text = free_text
          @revision = revision
          @locale = locale
          @calendar = calendar
          @additional_information = additional_information
        end
      end
    end
  end
end