RSpec.describe Loyalty::Points do
  {"standard" => 42, "silver" => 84, "gold" => 126}.each do |tier, points|
    it "awards #{points} points to a #{tier} customer for $42.99" do
      expect(described_class.for(Customer.new(tier:), spent_cents: 4299)).to eq(points)
    end
  end

  [0, -500].each do |spent|
    it "awards nothing for #{spent} cents" do
      expect(described_class.for(Customer.new(tier: "gold"), spent_cents: spent)).to eq(0)
    end
  end

  {99 => 0, 100 => 100, 250 => 200}.each do |points, cents|
    it "redeems #{points} points for #{cents} cents" do
      expect(described_class.redeemable_cents(points)).to eq(cents)
    end
  end
end
