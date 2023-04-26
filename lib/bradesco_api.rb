# frozen_string_literal: true
require 'sorbet-runtime'

Dir.glob('bradesco_api/**/*.rb', base: __dir__).each do |filepath|
  require_relative filepath
end

module BradescoApi
end
