# frozen_string_literal: true
require_relative 'config/boot'

module BradescoApi
  class Gateway
    extend T::Sig

    sig { returns(BradescoApi::Entity::System::Setup) }
    attr_accessor :setup

    sig do
      params(setup: BradescoApi::Entity::System::Setup).void
    end
    def initialize(setup:)
      @setup = setup
    end

    def charge
      BradescoApi::Services::Pix::Charge.new(setup: @setup)
    end

    def refund
      BradescoApi::Services::Pix::Refund.new(setup: @setup)
    end
  end
end
