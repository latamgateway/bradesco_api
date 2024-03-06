module BradescoApi
  module Entity
    module Pix
      module Attributes
        class PixData
          extend T::Sig
          sig { returns(String) }
          attr_accessor :payment_id, :identifier, :date

          sig { returns(Float) }
          attr_accessor :amount

          sig { returns(BradescoApi::Entity::Pix::Attributes::Payer) }
          attr_accessor :payer

          sig { returns(T::Array[BradescoApi::Entity::Pix::Attributes::Reversal]) }
          attr_accessor :reversals

          sig do  params(
            payment_id: String,
            identifier: String,
            date: String,
            amount: Float,
            payer: BradescoApi::Entity::Pix::Attributes::Payer,
            reversals: T::Array[BradescoApi::Entity::Pix::Attributes::Reversal]
          ).void
          end
          def initialize(
            payment_id:,
            identifier:,
            date:,
            amount:,
            payer:,
            reversals: []
          )
            @payment_id = payment_id
            @identifier = identifier
            @date = date
            @amount = amount
            @payer = payer
            @reversals = reversals
          end
        end
      end
    end
  end
end
