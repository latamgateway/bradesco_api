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

        sig { returns(T.nilable(BradescoApi::Entity::Pix::RefundResponseTime)) }
        attr_accessor :time

        sig { params(payload: String).void }
        def initialize(payload)
          data = JSON.parse(payload)

          super(
            identifier: data['id'],
            e2eid: '',
            value: data['valor'],
            operation: data['natureza'],
            description: data['descricao']
          )

          @status = status
          @rtr_id = rtr_id

          time = nil
          if data.include?('horario')
            creation = data['horario']['solicitacao'] if data['horario'].include?('solicitacao')
            settlement = data['horario']['liquidacao'] if data['horario'].include?('liquidacao')
            cause = data['horario']['motivo'] if data['horario'].include?('motivo')

            time = BradescoApi::Entity::Pix::RefundResponseTime.new(
              creation: creation,
              settlement: settlement,
              cause: cause
            )
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
