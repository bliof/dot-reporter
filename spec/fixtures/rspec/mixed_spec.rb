RSpec.describe "Mixed Spec" do
  8.times do |i|
    it "passes #{i}" do
      expect(1).to eq(1)
    end
  end
  it "fails" do
    expect(1).to eq(2)
  end
  7.times do |i|
    it "passes #{i+8}" do
      expect(1).to eq(1)
    end
  end
end
