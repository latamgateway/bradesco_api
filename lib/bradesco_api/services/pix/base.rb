require "base64"
require "json"

module BradescoApi
  module Services
    module Pix
      class Base
        extend T::Sig

        sig { returns(T::Hash[Symbol, T.untyped]) }
        def headers
          st = BradescoApi::Services::System::Token.new()
          token = st.create

          headers = {
            'Authorization': "Bearer #{token.access_token}",
            'Content-Type': 'application/json'
          }
        end
      end
    end
  end
end
