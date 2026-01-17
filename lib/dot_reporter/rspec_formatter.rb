require 'rspec/core/formatters/base_formatter'
require_relative 'formatter'

module DotReporter
  class RSpecFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self, :start, :example_passed, :example_failed, :example_pending, :close

    def initialize(output)
      super(output)
      @dot_formatter = DotReporter::Formatter.new(output)
    end

    def start(notification)
      @dot_formatter.start(notification.count)
    end

    def example_passed(_notification)
      @dot_formatter.example_passed
    end

    def example_failed(_notification)
      @dot_formatter.example_failed
    end

    def example_pending(_notification)
      @dot_formatter.example_pending
    end

    def close(_notification)
      @dot_formatter.close
    end
  end
end
