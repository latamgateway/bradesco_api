require "base64"
require "json"

module BradescoApi
  module Services
    module Pix
      class Refund < BradescoApi::Services::Pix::Base
        extend T::Sig

        sig do
          params(payment: BradescoApi::Entity::Pix::Refund)
            .returns(T.any(BradescoApi::Entity::Pix::RefundResponse, BradescoApi::Entity::Errors::ResponseApi))
        end
        def create(payment)
          endpoint = "/v2/pix/#{payment.e2eid}/devolucao/#{payment.identifier}"

          http = BradescoApi::Utils::HTTP.new()

          response = http.put(
            endpoint: endpoint,
            payload: payment.serialize,
            headers: headers
          )

          return BradescoApi::Entity::Pix::RefundResponse.new(response.read_body) if response.kind_of? Net::HTTPSuccess
          BradescoApi::Entity::Errors::ResponseApi.new(response.read_body)
        end

        sig do
          params(e2eid, String, identifier: String)
            .returns(T.any(BradescoApi::Entity::Pix::RefundResponse, BradescoApi::Entity::Errors::ResponseApi))
        end
        def get(identifier)
          endpoint = "/v2/pix/#{e2eid}/devolucao/#{identifier}"

          http = BradescoApi::Utils::HTTP.new()

          response = http.get(
            endpoint: endpoint,
            headers: headers
          )

          return BradescoApi::Entity::Pix::RefundResponse.new(response.read_body) if response.kind_of? Net::HTTPSuccess
          BradescoApi::Entity::Errors::ResponseApi.new(response.read_body)
        end
      end
    end
  end
end
