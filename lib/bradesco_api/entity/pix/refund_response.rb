module BradescoApi
  module Entity
    module Pix
      class RefundResponseTime
        extend T::Sig

        sig { returns(String) }
        attr_accessor :creation, :settlement

        sig do
          params(
            creation: String,
            settlement: String
          ).void
        end
        def initialize(
          creation: '',
          settlement: ''
        )
          @creation = creation
          @settlement = settlement
        end

      end

      class RefundResponse < BradescoApi::Entity::Pix::Refund
        extend T::Sig

        sig { returns(String) }
        attr_accessor :status, :rtr_id, :json

        sig { returns(T.nilable(BradescoApi::Entity::Pix::RefundResponseTime)) }
        attr_accessor :time

        sig { params(payload: String).void }
        def initialize(payload)
          data = JSON.parse(payload)

          super(
            identifier: data['id'],
            e2eid: '',
            value: data['valor'].to_f
          )

          @json = payload
          @status = data['status']
          @rtr_id = data['rtr_id']

          time = nil
          if data.include?('horario')
            payload = {}

            payload[:creation] = data['horario']['solicitacao'] if data['horario'].include?('solicitacao')
            payload[:settlement] = data['horario']['liquidacao'] if data['horario'].include?('liquidacao')

            time = BradescoApi::Entity::Pix::RefundResponseTime.new(**payload)
          end

          @time = time
        end

        def serialize
          raise NoMethodError
        end
      end
    end
  end
end
