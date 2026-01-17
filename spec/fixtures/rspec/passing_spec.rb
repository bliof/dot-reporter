RSpec.describe "Passing Spec" do
  16.times do |i|
    it "passes #{i}" do
      expect(1).to eq(1)
    end
  end
end
