module BradescoApi
  module Entity
    module Security
      class SSLConfig
        extend T::Sig

        sig { returns(String) }
        attr_accessor :key, :cert

        sig { params(key: String, cert: String).void }
        def initialize(key:, cert: '')
          @key = key
          @cert = cert
        end
      end
    end
  end
end