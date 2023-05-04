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
          params(payload: String).void
        end

        def initialize(payload)
          data = JSON.parse(payload)

          falts = []
          if data.has_key?('violacoes')
            data['violacoes'].each do |falt|
              d = BradescoApi::Entity::Errors::Falt.new(
                reason: falt['razao'],
                property: falt['propriedade'],
                value: falt['valor'],
                )

              falts << d
            end
          end


          @status = data['status'].to_s || '500'
          @type = data['type']
          @title = data['title']
          @falts = falts
          @related_id = data['correlationId'] || ''
        end

      end
    end
  end
end
