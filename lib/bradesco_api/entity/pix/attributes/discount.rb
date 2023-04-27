module BradescoApi
  module Entity
    module Pix
      module Attributes
        class Discount < BradescoApi::Entity::Pix::Attributes::CommonFieldsValue
          extend T::Sig

          sig { returns(T::Array[BradescoApi::Entity::Pix::Attributes::FixedDateDiscount]) }
          attr_accessor :fixed_date_discount

          sig do
            params(
              modality: String,
              percentage_value: String,
              fixed_date_discount: T::Array[BradescoApi::Entity::Pix::Attributes::FixedDateDiscount]
            ).void
          end
          def initialize(modality: , percentage_value:, fixed_date_discount: [])
            @fixed_date_discount = fixed_date_discount
            super(modality: modality, percentage_value: percentage_value)
          end
        end
      end
    end
  end
end