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
          endpoint = "/v2/cobv-emv/#{charge.identifier}"
          http = BradescoApi::Utils::HTTP.new(endpoint)
          response = http.put(payload: charge.serialize, headers: headers)
          BradescoApi::Entity::Pix::ChargeResponse.new(response.read_body)
        end

        sig do
          params(identifier: String)
            .returns(BradescoApi::Entity::Pix::ChargeResponse)
        end
        def get(identifier)
          endpoint = "/v2/cobv/#{identifier}"
          http = BradescoApi::Utils::HTTP.new(endpoint)
          response = http.get(headers: headers)
          BradescoApi::Entity::Pix::ChargeResponse.new(response.read_body)
        end
      end
    end
  end
end
