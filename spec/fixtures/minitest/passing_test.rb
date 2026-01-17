require 'minitest/autorun'
require 'dot_reporter'

# Override Minitest's plugin loading to inject our reporter
module DotReporterPlugin
  def self.minitest_plugin_init(options)
    # Remove default reporters if we want to replace them
    # But Minitest initializes reporter inside run, just before calling plugins.

    # We can access Minitest.reporter here

    # Clear existing reporters (Progress and Summary)
    Minitest.reporter.reporters.clear

    # Add our reporter
    Minitest.reporter << DotReporter::MinitestFormatter.new(options[:io] || $stdout)
  end
end

Minitest.extensions << 'dot_reporter'
# We need to make sure 'dot_reporter_plugin' is required or defined in a way Minitest finds it?
# Actually Minitest searches for "minitest/*_plugin.rb".
# But if we manually add to extensions, it tries to call plugin_dot_reporter_init.
# Wait, the method name is `plugin_#{name}_init`.

module Minitest
  def self.plugin_dot_reporter_init(options)
     Minitest.reporter.reporters.clear
     Minitest.reporter << DotReporter::MinitestFormatter.new(options[:io] || $stdout)
  end
end

class PassingTest < Minitest::Test
  16.times do |i|
    define_method("test_pass_#{i}") do
      assert_equal 1, 1
    end
  end
end
