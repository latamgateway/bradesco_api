module BradescoApi
  module Utils
    class HTTP
      extend T::Sig

      sig do
        params(
          ssl_config: BradescoApi::Entity::Security::SSLConfig
        ).void
      end

      def initialize(ssl_config)
        @ssl_config = ssl_config
      end

      sig do
        params(
          uri: String,
          payload: String,
          headers: T::Hash[String, String],
        ).returns(T.untyped)
      end
      def post(uri:, payload:, headers: {})
        url = URI(uri)

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        https.cert = OpenSSL::X509::Certificate.new(@ssl_config.cert)
        https.key = OpenSSL::PKey::RSA.new(@ssl_config.key)

        request = Net::HTTP::Post.new(url)
        headers.each do |key, value|
          request[key] = value
        end

        request.body = payload

        https.request(request)
      end

      sig do
        params(
          uri: String,
          payload: String,
          headers: T::Hash[String, String],
          ).returns(T.untyped)
      end

      def put(uri:, payload:, headers: {})
        url = URI(uri)

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        https.cert = OpenSSL::X509::Certificate.new(@ssl_config.cert)
        https.key = OpenSSL::PKey::RSA.new(@ssl_config.key)

        request = Net::HTTP::Put.new(url)
        headers.each do |key, value|
          request[key] = value
        end

        request.body = payload

        https.request(request)
      end

    end
  end
end