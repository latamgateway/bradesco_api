module BradescoApi
  module Entity
    module System
      class Token
        extend T::Sig

        sig { returns(String) }
        attr_accessor :access_token, :token_type

        sig { returns(Integer) }
        attr_accessor :expires_in

        sig { params(access_token: String, token_type: String, expires_in: Integer).void }
        def initialize(
          access_token:,
          token_type:,
          expires_in: ''
        )
          @access_token = access_token
          @token_type = token_type
          @expires_in = expires_in
        end
      end
    end
  end
end