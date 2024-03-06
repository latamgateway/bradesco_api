module BradescoApi
  module Entity
    module Pix
      module Attributes
        class Reversal
          extend T::Sig
          sig { returns(String) }
          attr_accessor :id, :reason, :identifier, :status

          sig { returns(Float) }
          attr_accessor :amount

          sig { returns(BradescoApi::Entity::Pix::Attributes::ReversalTime) }
          attr_accessor :time

          sig do  params(
            id: String,
            identifier: String,
            status: String,
            amount: String,
            time: BradescoApi::Entity::Pix::Attributes::ReversalTime,
            reason: String,
          ).void
          end
          def initialize(
            id:,
            identifier:,
            status:,
            amount:,
            time:,
            reason:''
          )
            @id = id
            @identifier = identifier
            @status = status
            @amount = amount
            @time = time
          end
        end
      end
    end
  end
end
