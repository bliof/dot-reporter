# frozen_string_literal: true

RSpec.describe '5 Passing Tests' do
  5.times do |i|
    it "passes #{i}" do
      expect(1).to eq(1)
    end
  end
end
