module BradescoApi
  module Entity
    module Pix
      module Attributes
        class ReversalTime
          extend T::Sig
          sig { returns(String) }
          attr_accessor :settlement, :request

          sig { params(settlement: String, request: String).void }
          def initialize(settlement:'', request:'')
            @settlement = settlement
            @request = request
          end
        end
      end
    end
  end
end
