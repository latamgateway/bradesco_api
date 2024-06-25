require "base64"
require "json"

module BradescoApi
  module Services
    module Pix
      class Base
        extend T::Sig

        sig do
          params(setup: BradescoApi::Entity::System::Setup).void
        end
        def initialize(setup:)
          @setup = setup
        end

        sig { returns(T::Hash[Symbol, T.untyped]) }
        def headers
          st = BradescoApi::Services::System::Token.new(setup: @setup)
          token = st.create

          {
            'Authorization': "Bearer #{token.access_token}",
            'Content-Type': 'application/json'
          }
        end
      end
    end
  end
end
