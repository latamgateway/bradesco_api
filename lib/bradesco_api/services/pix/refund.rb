require "base64"
require "json"

module BradescoApi
  module Services
    module Pix
      class Refund < BradescoApi::Services::Pix::Base
        extend T::Sig

        sig do
          params(payment: BradescoApi::Entity::Pix::Refund)
            .returns(BradescoApi::Entity::Pix::RefundResponse)
        end
        def create(payment)
          endpoint = "/v2/pix/#{payment.e2eid}/devolucao/#{payment.identifier}"

          http = BradescoApi::Utils::HTTP.new(endpoint)

          response = http.put(
            payload: payment.serialize,
            headers: headers
          )

          BradescoApi::Entity::Pix::RefundResponse.new(response.read_body)
        end

        sig do
          params(e2eid, String, identifier: String)
            .returns(BradescoApi::Entity::Pix::RefundResponse)
        end
        def get(identifier)
          endpoint = "/v2/pix/#{e2eid}/devolucao/#{identifier}"

          http = BradescoApi::Utils::HTTP.new(endpoint)

          response = http.get(
            headers: headers
          )

          BradescoApi::Entity::Pix::RefundResponse.new(response.read_body)
        end
      end
    end
  end
end
