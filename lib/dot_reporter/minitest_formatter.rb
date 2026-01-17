require 'minitest'
require_relative 'formatter'

module DotReporter
  class MinitestFormatter < Minitest::AbstractReporter
    def initialize(io = $stdout, options = {})
      super() # AbstractReporter doesn't take args in init but Minitest::Reporters might
      @io = io
      @dot_formatter = DotReporter::Formatter.new(io)
    end

    def start
      @dot_formatter.start(0) # Minitest doesn't always know total count upfront easily
    end

    def record(result)
      if result.passed?
        @dot_formatter.example_passed
      elsif result.skipped?
        @dot_formatter.example_pending
      else
        @dot_formatter.example_failed
      end
    end

    def report
      @dot_formatter.close
    end

    # Compatibility with minitest-reporters
    def self.new(io = $stdout, options = {})
      super
    end
  end
end
