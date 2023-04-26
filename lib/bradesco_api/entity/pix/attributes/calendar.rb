module BradescoApi
  module Entity
    module Pix
      module Attributes
        class Calendar
          extend T::Sig
          sig { returns(String) }
          attr_accessor :due_date, :creation

          sig { returns(Integer) }
          attr_accessor :limit_after_due_date

          sig { params(due_date: String, limit_after_due_date: Integer, creation: String).void }
          def initialize(due_date:, limit_after_due_date:, creation: '')
            @due_date = due_date
            @limit_after_due_date = limit_after_due_date
            @creation = creation
          end
        end
      end
    end
  end
end
