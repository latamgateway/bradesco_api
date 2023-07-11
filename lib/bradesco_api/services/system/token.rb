module BradescoApi
  module Services
    module System
      class Token

        def initialize()
          @client_id = ENV['BRADESCO_PIX_CLIENT_ID']
          @client_secret = ENV['BRADESCO_PIX_CLIENT_SECRET']

          puts @client_id
          puts @client_secret
        end

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

          puts response

          if response.kind_of? Net::HTTPSuccess
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