# frozen_string_literal: true

RSpec.describe 'Fail in 8' do
  7.times do |i|
    it "passes #{i}" do
      expect(1).to eq(1)
    end
  end
  it 'fails' do
    expect(1).to eq(2)
  end
end
