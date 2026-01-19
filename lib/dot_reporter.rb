# frozen_string_literal: true

require_relative 'dot_reporter/version'
require_relative 'dot_reporter/terminal'
require_relative 'dot_reporter/colorizer'
require_relative 'dot_reporter/formatter'
begin
  require_relative 'dot_reporter/rspec_formatter'
rescue LoadError, NameError
  # RSpec not present or failed to load
end
require_relative 'dot_reporter/minitest_formatter'

module DotReporter
  class Error < StandardError; end
end
