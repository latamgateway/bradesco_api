module BradescoApi
  module Entity
    module Pix
      module Attributes
        class Customer
          extend T::Sig

          sig { returns(String) }
          attr_accessor :address, :city, :state, :zip_code, :name, :email, :document

          sig { params(document: String, name: String, address: String, city: String, state: String, zip_code: String, email: String).void }
          def initialize(
            document:,
            name:,
            address:'',
            city:'',
            state:'',
            zip_code:'',
            email:''
          )
            @address = address
            @city = city
            @state = state
            @zip_code = zip_code
            @name = name
            @email = email
            @document = document
          end
        end
      end
    end
  end
end