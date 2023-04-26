module BradescoApi
  module Entity
    module Pix
      module Attributes
        class Locale
          extend T::Sig
          sig { returns(Integer) }
          attr_accessor :id, :type, :location, :creation

          sig { params(id: Integer, type: String, location: String, creation: String).void }
          def initialize(id:, type:  '', location:  '', creation:  '')
            @id = id
            @type = type
            @location = location
            @creation = creation
          end
        end
      end
    end
  end
end