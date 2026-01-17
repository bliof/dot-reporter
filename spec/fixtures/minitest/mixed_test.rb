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

class MixedTest < Minitest::Test
  8.times do |i|
    define_method("test_pass_#{i}") do
      assert_equal 1, 1
    end
  end

  def test_fail
    assert_equal 1, 2
  end

  7.times do |i|
    define_method("test_pass_#{i+8}") do
      assert_equal 1, 1
    end
  end
end
