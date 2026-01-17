# frozen_string_literal: true

require 'open3'
require 'rspec'

RSpec.describe 'Rendering Integration' do
  def run_spec(file)
    cmd = "rspec #{file} --format DotReporter::RSpecFormatter --require ./lib/dot_reporter"
    stdout, _stderr, _status = Open3.capture3(cmd)
    stdout
  end

  it 'renders 14 passing tests as ⣿⡟' do
    output = run_spec('spec/fixtures/rspec/render_14_pass_spec.rb')
    # ⣿ (green) then ⡟ (green)
    # Note: formatter adds colors.
    expect(output).to include('⣿')
    expect(output).to include('⡟')
    # Verify count summary
    expect(output).to include('Total Tests:       14')
  end

  it 'renders 5 passing tests as ⡏' do
    output = run_spec('spec/fixtures/rspec/render_5_pass_spec.rb')
    expect(output).to include('⡏')
    expect(output).to include('Total Tests:       5')
  end

  it 'renders failure in batch as red block' do
    output = run_spec('spec/fixtures/rspec/render_1_fail_in_8_spec.rb')
    # 8 tests total. One char ⣿. Should be red.
    # Red is \e[31m
    expect(output).to include("\e[31m⣿\e[0m")
    expect(output).to include('Total Tests:       8')
    expect(output).to include('✗ Failed:         1')
  end
end
