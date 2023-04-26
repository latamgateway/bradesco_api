module BradescoApi
  module Entity
    module Security
      class Credentials
        extend T::Sig

        sig { returns(String) }
        attr_accessor :client_id, :client_secret, :grant_type

        sig { params(client_id: String, client_secret: String, grant_type: String).void }
        def initialize(client_id:, client_secret:, grant_type:)
          @client_id = client_id
          @client_secret = client_secret
          @grant_type = grant_type
        end

      end
    end
  end
end