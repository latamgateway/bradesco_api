require "base64"
require "json"

module BradescoApi
  module Services
    module Pix
      class WithDueDate
        extend T::Sig

        sig do
          params(charge: BradescoApi::Entity::Pix::Charge)
            .returns(T.any(BradescoApi::Entity::Pix::ChargeResponse, BradescoApi::Entity::Errors::ResponseApi))
        end
        def create(charge)
          endpoint = "/v2/cobv-emv/#{charge.identifier}"

          http = BradescoApi::Utils::HTTP.new()

          response = http.put(
            endpoint: endpoint,
            payload: charge.serialize,
            headers: headers
          )

          return BradescoApi::Entity::Pix::ChargeResponse.new(response.read_body) if response.kind_of? Net::HTTPSuccess
          serialize_response_error(response.read_body)
        end

        sig do
          params(identifier: String)
            .returns(T.any(BradescoApi::Entity::Pix::ChargeResponse, BradescoApi::Entity::Errors::ResponseApi))
        end
        def get(identifier)
          endpoint = "/v2/cobv/#{identifier}"

          http = BradescoApi::Utils::HTTP.new()

          response = http.get(
            endpoint: endpoint,
            headers: headers
          )

          build_response(response)
        end

        sig do
          params(payment: BradescoApi::Entity::Pix::Refund)
            .returns(T.any(BradescoApi::Entity::Pix::RefundResponse, BradescoApi::Entity::Errors::ResponseApi))
        end
        def refund(payment)
          endpoint = "/v2/pix/#{payment.e2eid}/devolucai/#{payment.identifier}"

          http = BradescoApi::Utils::HTTP.new()

          response = http.put(
            endpoint: endpoint,
            payload: payment.serialize,
            headers: headers
          )

          return BradescoApi::Entity::Pix::RefundResponse.new(response.read_body) if response.kind_of? Net::HTTPSuccess
          serialize_response_error(response.read_body)
        end

        private

        def build_response(response)

        end

        def headers
          st = BradescoApi::Services::System::Token.new()
          token = st.create

          headers = {
            'Authorization': "Bearer #{token.access_token}",
            'Content-Type': 'application/json'
          }
        end

        def deserialize_response(payload)

        end

        def serialize_response_error(payload)
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

          BradescoApi::Entity::Errors::ResponseApi.new(
            status: data['status'].to_s || '500',
            type: data['type'],
            title: data['title'],
            falts: falts,
            related_id: data['correlationId'] || '',
          )
        end


      end
    end
  end
end
