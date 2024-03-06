module BradescoApi
  module Entity
    module Pix
      module Attributes
        class Payer
          extend T::Sig
          sig { returns(String) }
          attr_accessor :name, :document

          sig do  params(
            name: String,
            document: String
          ).void
          end
          def initialize(
            name:,
            document:
          )
            @name = name
            @document = document
          end
        end
      end
    end
  end
end
