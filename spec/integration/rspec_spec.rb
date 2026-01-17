require 'open3'
require 'rspec'

RSpec.describe "RSpec Integration" do
  def run_spec(file)
    # Include lib in load path
    cmd = "rspec #{file} --format DotReporter::RSpecFormatter --require ./lib/dot_reporter"
    stdout, stderr, status = Open3.capture3(cmd)
    stdout
  end

  it "displays correct output for passing tests" do
    output = run_spec("spec/fixtures/rspec/passing_spec.rb")
    expect(output).to include("Dot Reporter Summary")
    expect(output).to include("Total Tests:       16")
    expect(output).to include("✓ Passed:         16")
    expect(output).to include("⣿")
  end

  it "displays correct output for failing tests" do
    output = run_spec("spec/fixtures/rspec/failing_spec.rb")
    expect(output).to include("Total Tests:       16")
    expect(output).to include("✗ Failed:         16")
    expect(output).to include("\e[31m") # Red color code
  end

  it "displays correct output for mixed tests" do
    output = run_spec("spec/fixtures/rspec/mixed_spec.rb")
    expect(output).to include("Total Tests:       16")
    expect(output).to include("✓ Passed:         15")
    expect(output).to include("✗ Failed:         1")
  end
end
