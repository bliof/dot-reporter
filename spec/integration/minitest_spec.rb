require 'open3'
require 'rspec'

RSpec.describe "Minitest Integration" do
  def run_test(file)
    # Include lib in load path
    cmd = "ruby -Ilib #{file}"
    stdout, stderr, status = Open3.capture3(cmd)
    stdout
  end

  it "displays correct output for passing tests" do
    output = run_test("spec/fixtures/minitest/passing_test.rb")

    expect(output).to include("Dot Reporter Summary")
    expect(output).to include("Total Tests:       16")
    expect(output).to include("✓ Passed:         16")
    expect(output).to include("⣿")
  end

  it "displays correct output for failing tests" do
    output = run_test("spec/fixtures/minitest/failing_test.rb")

    expect(output).to include("Dot Reporter Summary")
    expect(output).to include("Total Tests:       16")
    expect(output).to include("✗ Failed:         16")
    expect(output).to include("\e[31m")
  end

  it "displays correct output for mixed tests" do
    output = run_test("spec/fixtures/minitest/mixed_test.rb")

    expect(output).to include("Total Tests:       16")
    expect(output).to include("✓ Passed:         15")
    expect(output).to include("✗ Failed:         1")
  end
end
