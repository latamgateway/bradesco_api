module BradescoApi
  module Entity
    module Errors

      class Falt
        extend T::Sig

        sig { returns(String) }
        attr_accessor :reason, :property, :value

        sig do
          params(
            reason: String,
            property: String,
            value: String
          ).void
        end

        def initialize(reason:, property:, value:)
          @reason = reason
          @property = property
          @value = value
        end
      end

      class ResponseApi
        extend T::Sig

        sig { returns(String) }
        attr_accessor :type, :title, :status, :detail, :related_id

        sig { returns(T::Array[BradescoApi::Entity::Errors::Falt]) }
        attr_accessor :falts

        sig do
          params(
            status: String,
            type: String,
            title: String,
            falts: T::Array[BradescoApi::Entity::Errors::Falt],
            related_id: String,
          ).void
        end

        def initialize(
          status: ,
          type: '',
          title: '',
          falts: [],
          related_id: ''
        )
          @status = status
          @type = type
          @title = title
          @falts = falts
          @related_id = related_id
        end
      end
    end
  end
end
