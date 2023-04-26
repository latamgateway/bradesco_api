module BradescoApi
  module Entity
    module Pix
      module Attributes
        class AdditionalInformation
          extend T::Sig
          sig { returns(String) }
          attr_accessor :name, :value

          sig { params(name: String, value: String).void }
          def initialize(name:, value:)
            @name = name
            @value = value
          end
        end
      end
    end
  end
end