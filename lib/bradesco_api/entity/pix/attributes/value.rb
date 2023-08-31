module BradescoApi
  module Entity
    module Pix
      module Attributes
        class Value < BradescoApi::Entity::Pix::Attributes::CommonFieldsValue
          extend T::Sig

          sig { returns(String) }
          attr_accessor :original

          sig { returns(T.nilable(BradescoApi::Entity::Pix::Attributes::FineForDelay)) }
          attr_accessor :fine_for_delay

          sig { returns(T.nilable(BradescoApi::Entity::Pix::Attributes::Tax)) }
          attr_accessor :tax

          sig { returns(T.nilable(BradescoApi::Entity::Pix::Attributes::Discount)) }
          attr_accessor :discount

          sig { returns(T.nilable(BradescoApi::Entity::Pix::Attributes::Reduction)) }
          attr_accessor :reduction

          sig do
            params(
              original: Float,
              fine_for_delay: T.nilable(BradescoApi::Entity::Pix::Attributes::FineForDelay),
              tax: T.nilable(BradescoApi::Entity::Pix::Attributes::Tax),
              discount: T.nilable(BradescoApi::Entity::Pix::Attributes::Discount),
              reduction: T.nilable(BradescoApi::Entity::Pix::Attributes::Reduction)
            ).void
          end
          def initialize(
            original:,
            fine_for_delay: nil,
            tax: nil,
            discount: nil,
            reduction: nil
            )

            @original = original
            @fine_for_delay = fine_for_delay
            @tax = tax
            @discount = discount
            @reduction = reduction
          end
        end
      end
    end
  end
end
