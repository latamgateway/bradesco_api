module BradescoApi
  module Entity
    module Pix
      module Attributes
        class Discount
          extend T::Sig

          sig { returns(T::Array[BradescoApi::Entity::Pix::Attributes::FixedDateDiscount]) }
          attr_accessor :fixed_date_discount

          sig { returns(Integer) }
          attr_accessor :modality

          sig { returns(T.nilable(String)) }
          attr_accessor :percentage_value

          sig do
            params(
              modality: Integer,
              percentage_value: T.nilable(String),
              fixed_date_discount: T::Array[BradescoApi::Entity::Pix::Attributes::FixedDateDiscount]
            ).void
          end
          def initialize(modality:, percentage_value: nil, fixed_date_discount: [])
            @modality = modality
            @percentage_value = percentage_value
            @fixed_date_discount = fixed_date_discount
          end
        end
      end
    end
  end
end