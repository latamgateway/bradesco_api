require "base64"
require "json"

module BradescoApi
  module Services
    module Pix
      class Charge < BradescoApi::Services::Pix::Base
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
          BradescoApi::Entity::Errors::ResponseApi.new(response.read_body)
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

          return BradescoApi::Entity::Pix::ChargeResponse.new(response.read_body) if response.kind_of? Net::HTTPSuccess
          BradescoApi::Entity::Errors::ResponseApi.new(response.read_body)
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
          BradescoApi::Entity::Errors::ResponseApi.new(response.read_body)
        end
      end
    end
  end
end
