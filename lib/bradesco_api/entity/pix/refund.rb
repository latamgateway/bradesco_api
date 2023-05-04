require "json"

module BradescoApi
  module Entity
    module Pix
      class Refund
        extend T::Sig

        sig { returns(String) }
        attr_accessor :identifier, :e2eid, :value, :operation, :description

        sig do
          params(
            identifier: String,
            e2eid: String,
            value: String,
            operation: String,
            description: String
          ).void
        end
        def initialize(
          identifier:,
          e2eid:,
          value:,
          operation: '',
          description: ''
        )
          @identifier = identifier
          @e2eid = e2eid
          @value = value
          @operation = operation
          @description = description
        end

        sig { returns(String) }
        def serialize
          payload = {
            "valor": @value
          }

          payload["natureza"] = @operation unless @operation.empty?
          payload["descricao"] = @description unless @description.empty?

          JSON.dump(payload)
        end
      end
    end
  end
end
