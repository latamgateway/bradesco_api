module BradescoApi
  module Services
    module System
      class Token
        extend T::Sig

        def initialize()
          @client_id = ENV['BRADESCO_PIX_CLIENT_ID']
          @client_secret = ENV['BRADESCO_PIX_CLIENT_SECRET']
        end

        # sig { returns(BradescoApi::Entity::System::Token) }
        def create
          endpoint = "/oauth/token"
          http = BradescoApi::Utils::HTTP.new(endpoint)

          basic = Base64.strict_encode64("#{@client_id}:#{@client_secret}")
          headers = {
            'Authorization': "Basic #{basic}",
            'Content-Type': 'application/x-www-form-urlencoded'
          }

          response = http.post(
            payload: "grant_type=client_credentials",
            headers: headers
          )

          data = JSON.parse(response.read_body)
          raise BradescoApi::Exceptions::BradescoError.new(
            reason: data["error"],
            message: data["error_description"]
          ) unless response.kind_of? Net::HTTPSuccess

          BradescoApi::Entity::System::Token.new(
            access_token: data['access_token'],
            token_type: data['token_type'],
            expires_in: data['expires_in']
          )
        end
      end
    end
  end
end