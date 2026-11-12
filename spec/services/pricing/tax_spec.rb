RSpec.describe Pricing::Tax do
  {
    ["CA", "electronics"] => 0.0725, ["CA", "grocery"] => 0.0,
    ["NY", "electronics"] => 0.04, ["NY", "apparel"] => 0.0,
    ["TX", "books"] => 0.0625, ["WA", "grocery"] => 0.065,
    ["OR", "electronics"] => 0.0, ["ZZ", "books"] => 0.0
  }.each do |(region, category), rate|
    it "charges #{rate} on #{category} shipped to #{region}" do
      expect(described_class.rate(region, category)).to eq(rate)
    end
  end

  it "taxes each line at its own category's rate" do
    order = create_order(ship_to_region: "CA", items: {
      create_product(category: "electronics", price_cents: 10_000) => 1,
      create_product(category: "grocery", price_cents: 5000) => 2
    })
    expect(described_class.new(order).cents).to eq(725)
  end

  it "charges no tax in Oregon" do
    order = create_order(ship_to_region: "OR", items: {create_product(price_cents: 99_999) => 3})
    expect(described_class.new(order).cents).to eq(0)
  end

  it "rounds per line" do
    order = create_order(ship_to_region: "TX", items: {create_product(price_cents: 999) => 1, create_product(price_cents: 1) => 1})
    expect(described_class.new(order).cents).to eq(62)
  end
end
