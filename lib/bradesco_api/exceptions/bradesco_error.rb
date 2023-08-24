module BradescoApi
  module Exceptions
    class BradescoError < StandardError

      extend T::Sig

      sig { returns(T.nilable(String)) }
      attr_accessor :reason, :message, :value

      sig do
        params(
          reason: T.nilable(String),
          message: T.nilable(String),
          value: T.nilable(String)
        ).void
      end
      def initialize(reason: nil, message: nil, value: nil)
        @reason = reason
        @message = message
        @value = value
        super("#{reason} - #{message} - #{value}")
      end
    end
  end
end