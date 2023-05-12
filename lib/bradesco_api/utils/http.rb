module BradescoApi
  module Utils
    class HTTP
      extend T::Sig

      sig { params(endpoint: String).void }
      def initialize(endpoint)
        pfx_file = ENV['BRADESCO_PIX_PFX_PATH']
        pfx_password = ENV['BRADESCO_PIX_PFX_PASSWORD']
        pkcs = OpenSSL::PKCS12.new(File.read(pfx_file), pfx_password)
        @key = pkcs.key.to_pem
        @cert = pkcs.certificate.to_pem
        @base_url = ENV['BRADESCO_PIX_BASE_URL']

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
        request = Net::HTTP::Post.new(@url)
        headers.each do |key, value|
          request[key] = value
        end

        request.body = payload

        @https.request(request)
      end

      sig do
        params(
          payload: String,
          headers: T::Hash[String, String],
          ).returns(T.untyped)
      end
      def put(payload:, headers: {})
        request = Net::HTTP::Put.new(@url)
        headers.each do |key, value|
          request[key] = value
        end

        request.body = payload

        @https.request(request)
      end

      sig do
        params(
          headers: T::Hash[String, String],
          ).returns(T.untyped)
      end
      def get(headers: {})
        request = Net::HTTP::Get.new(@url)
        headers.each do |key, value|
          request[key] = value
        end

        @https.request(request)
      end

    end
  end
end
