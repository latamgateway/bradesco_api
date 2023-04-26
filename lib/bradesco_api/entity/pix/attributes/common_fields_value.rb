module BradescoApi
  module Entity
    module Pix
      module Attributes
        class CommonFieldsValue
          extend T::Sig

          sig { returns(String) }
          attr_accessor :modality, :percentage_value

          sig { params(modality: String, percentage_value: String).void }
          def initialize(modality:, percentage_value:)
            @modality = modality
            @percentage_value = percentage_value
          end
        end
      end
    end
  end
end