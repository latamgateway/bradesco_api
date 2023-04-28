module BradescoApi
  module Entity
    module Pix
      module Attributes
        class FixedDateDiscount
          extend T::Sig

          sig { returns(String) }
          attr_accessor :date
          
          sig { returns(String) }
          attr_accessor :percentage_value

          sig { params(date: String, percentage_value: String).void }
          def initialize(date:, percentage_value: nil)
            @date = date
            @percentage_value = percentage_value
          end
        end
      end
    end
  end
end