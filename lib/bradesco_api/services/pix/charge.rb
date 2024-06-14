require "base64"
require "json"

module BradescoApi
  module Services
    module Pix
      class Charge < BradescoApi::Services::Pix::Base
        extend T::Sig

        sig do
          params(charge: BradescoApi::Entity::Pix::Charge)
            .returns(BradescoApi::Entity::Pix::ChargeResponse)
        end
        def create(charge)
          endpoint = "/v2/cobv/#{charge.identifier}"
          http = BradescoApi::Utils::HTTP.new(endpoint: endpoint, setup: @setup)
          response = http.put(payload: charge.serialize, headers: headers)

          raise_error(
            "Error when creating the pix charge",
            response.read_body) unless response.kind_of? Net::HTTPSuccess

          BradescoApi::Entity::Pix::ChargeResponse.new(response.read_body)
        end

        sig do
          params(identifier: String)
            .returns(BradescoApi::Entity::Pix::ChargeResponse)
        end
        def get(identifier)
          endpoint = "/v2/cobv/#{identifier}"
          http = BradescoApi::Utils::HTTP.new(endpoint: endpoint, setup: @setup)
          response = http.get(headers: headers)

          raise_error(
            "Error when consulting the pix charge",
            response.read_body) unless response.kind_of? Net::HTTPSuccess

          BradescoApi::Entity::Pix::ChargeResponse.new(response.read_body)
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
