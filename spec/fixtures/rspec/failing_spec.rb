RSpec.describe "Failing Spec" do
  16.times do |i|
    it "fails #{i}" do
      expect(1).to eq(2)
    end
  end
end
