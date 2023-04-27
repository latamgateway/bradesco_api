module BradescoApi
  module Utils
    class HTTP
      extend T::Sig

      def initialize()
        pfx_file = ENV['BRADESCO_PIX_PFX_PATH']
        pfx_password = ENV['BRADESCO_PIX_PFX_PASSWORD']

        pkcs = OpenSSL::PKCS12.new(File.read(pfx_file), pfx_password)
        @key = pkcs.key.to_pem
        @cert = pkcs.certificate.to_pem
        @base_url = ENV['BRADESCO_PIX_BASE_URL']
      end

      sig do
        params(
          endpoint: String,
          payload: String,
          headers: T::Hash[String, String],
        ).returns(T.untyped)
      end
      def post(endpoint:, payload:, headers: {})
        url = URI("#{@base_url}#{endpoint}")

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        https.cert = OpenSSL::X509::Certificate.new(@cert)
        https.key = OpenSSL::PKey::RSA.new(@key)

        request = Net::HTTP::Post.new(url)
        headers.each do |key, value|
          request[key] = value
        end

        request.body = payload

        https.request(request)
      end

      sig do
        params(
          endpoint: String,
          payload: String,
          headers: T::Hash[String, String],
          ).returns(T.untyped)
      end

      def put(endpoint:, payload:, headers: {})
        url = URI("#{@base_url}#{endpoint}")

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        https.cert = OpenSSL::X509::Certificate.new(@cert)
        https.key = OpenSSL::PKey::RSA.new(@key)

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