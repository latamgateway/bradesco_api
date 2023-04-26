module BradescoApi
  module Services
    module System
      class Token
        extend T::Sig

        sig { returns(BradescoApi::Entity::Security::SSLConfig) }
        attr_accessor :ssl_config

        sig { returns(BradescoApi::Entity::Security::Credentials) }
        attr_accessor :credentials

        sig do
          params(
            ssl_config: BradescoApi::Entity::Security::SSLConfig,
            credentials: BradescoApi::Entity::Security::Credentials
          ).void
        end

        def initialize(ssl_config:, credentials:)
          @ssl_config = ssl_config
          @credentials = credentials
        end

        def create
          puts "Cheguei aqui"
          http = BradescoApi::Utils::HTTP.new(@ssl_config)
          # TODO: CHANGE VIA ENV VARS
          uri = "https://qrpix-h.bradesco.com.br/oauth/token"

          basic = Base64.strict_encode64("#{@credentials.client_id}:#{@credentials.client_secret}")

          headers = {
            'Authorization': "Basic #{basic}",
            'Content-Type': 'application/x-www-form-urlencoded'
          }

          response = http.post(
            uri: uri,
            payload: "grant_type=client_credentials",
            headers: headers
          )

          if response.code.to_i == 200
            data = JSON.parse(response.read_body)
            token = BradescoApi::Entity::System::Token.new(
              access_token: data['access_token'],
              token_type: data['token_type'],
              expires_in: data['expires_in']
            )

            token
          end

          # raise exception or something
        end
      end
    end
  end
end