require 'minitest/autorun'
require 'dot_reporter'

# Manually register plugin hook
Minitest.extensions << 'dot_reporter'

module Minitest
  def self.plugin_dot_reporter_init(options)
     Minitest.reporter.reporters.clear
     Minitest.reporter << DotReporter::MinitestFormatter.new(options[:io] || $stdout)
  end
end

class FailingTest < Minitest::Test
  16.times do |i|
    define_method("test_fail_#{i}") do
      assert_equal 1, 2
    end
  end
end
