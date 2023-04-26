module BradescoApi
  module Entity
    module Pix
      module Attributes
        class FixedDateDiscount
          extend T::Sig

          sig { returns(String) }
          attr_accessor :data, :percentage_value

          sig { params(data: String, percentage_value: String).void }
          def initialize(data:, percentage_value:)
            @data = data
            @percentage_value = percentage_value
          end
        end
      end
    end
  end
end