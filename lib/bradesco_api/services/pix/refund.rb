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
          http = BradescoApi::Utils::HTTP.new(endpoint: endpoint, setup: @setup)
          response = http.put(payload: payment.serialize, headers: headers)

          raise_error(
            "Error when consulting the pix refund",
            response.read_body) unless response.kind_of? Net::HTTPSuccess

          BradescoApi::Entity::Pix::RefundResponse.new(response.read_body)
        end

        sig do
          params(e2eid, String, identifier: String)
            .returns(BradescoApi::Entity::Pix::RefundResponse)
        end
        def get(identifier)
          endpoint = "/v2/pix/#{e2eid}/devolucao/#{identifier}"
          http = BradescoApi::Utils::HTTP.new(endpoint: endpoint, setup: @setup)
          response = http.get(headers: headers)

          raise_error(
            "Error when consulting the pix refund",
            response.read_body) unless response.kind_of? Net::HTTPSuccess

          BradescoApi::Entity::Pix::RefundResponse.new(response.read_body)
        end

        private

        def raise_error(message, body)
          raise BradescoApi::Exceptions::BradescoError.new(
            reason: message,
            message: body
          )
        end
      end
    end
  end
end
