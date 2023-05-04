module BradescoApi
  module Entity
    module Pix

      class RefundResponseTime
        extend T::Sig

        sig { returns(String) }
        attr_accessor :creation, :settlement, :cause

        sig do
          params(
            creation: String,
            settlement: String,
            cause: String
          ).void
        end
        def initialize(
          creation: '',
          settlement: '',
          cause: ''
        )
          @creation = creation
          @settlement = settlement
          @cause = cause
        end

      end

      class RefundResponse < BradescoApi::Entity::Pix::Refund
        extend T::Sig

        sig { returns(String) }
        attr_accessor :status, :rtr_id

        sig { returns(BradescoApi::Entity::Pix::RefundResponseTime) }
        attr_accessor :time

        sig { params(payload: String).void }
        def initialize(payload)
          # @status = status
          # @rtr_id = rtr_id
          # @time = time
          # super(identifier, e2eid, value, operation, description)
        end
      end
    end
  end
end
