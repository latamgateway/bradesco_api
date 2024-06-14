require "base64"

module BradescoApi
  module Utils
    class HTTP
      extend T::Sig

      sig do
        params(
          endpoint: String,
          setup: BradescoApi::Entity::System::Setup
        ).void
      end
      def initialize(endpoint:, setup:)
        # The pfx file is stored in environment variables in a base64 string
        pfx_base64 = setup.certificate
        pfx_file = Base64.decode64(pfx_base64)
        pfx_password = setup.password

        pkcs = OpenSSL::PKCS12.new(pfx_file, pfx_password)
        @key = pkcs.key.to_pem
        @cert = pkcs.certificate.to_pem
        @base_url = setup.base_url

        @url = URI("#{@base_url}#{endpoint}")
        @https = Net::HTTP.new(@url.host, @url.port)
        @https.use_ssl = true
        @https.cert = OpenSSL::X509::Certificate.new(@cert)
        @https.key = OpenSSL::PKey::RSA.new(@key)
      end

      sig do
        params(
          payload: String,
          headers: T::Hash[String, String],
        ).returns(T.untyped)
      end
      def post(payload:, headers: {})
        request = call('post', headers, payload)
        @https.request(request)
      end

      sig do
        params(
          payload: String,
          headers: T::Hash[String, String],
          ).returns(T.untyped)
      end
      def put(payload:, headers: {})
        request = call('put', headers, payload)
        @https.request(request)
      end

      sig do
        params(
          headers: T::Hash[String, String],
          ).returns(T.untyped)
      end
      def get(headers: {})
        request = call('get', headers)
        @https.request(request)
      end


      private

      sig do
        type_parameters(:Instance)
          .params(
            http_verb: String,
            headers: T::Hash[String, String],
            payload: T::nilable(String)).
          returns(T.untyped)
      end
      def call(http_verb, headers, payload = nil)
        http_request = parse_http_verb(http_verb)
        request = http_request.new(@url)
        headers.each do |key, value|
          request[key] = value
        end

        request.body = payload unless payload.nil?

        request
      end

      sig do
          params(verb: String)
          .returns(T.untyped)
      end
      def parse_http_verb(verb)
        case verb
        when 'get'
          return Net::HTTP::Get
        when 'post'
          return Net::HTTP::Post
        when 'put'
          return Net::HTTP::Put
        else
          raise BradescoApi::Exceptions::BradescoError.new("http_verb", "HTTP verb not mapped")
        end
      end

    end
  end
end
