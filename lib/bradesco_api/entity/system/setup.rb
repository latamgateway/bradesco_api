module BradescoApi
  module Entity
    module System
      class Setup
        extend T::Sig

        sig { returns(String) }
        attr_accessor :client_id, :client_secret, :base_url, :certificate, :password

        sig do
          params(
            client_id: String,
            client_secret: String,
            base_url: String,
            certificate: String,
            password: String
          ).void
        end
        def initialize(
          client_id:,
          client_secret:,
          base_url:,
          certificate:,
          password:
        )
          @client_id = client_id
          @client_secret = client_secret
          @base_url = base_url
          @certificate = certificate
          @password = password
        end
      end
    end
  end
end