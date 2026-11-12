RSpec.describe Shipping::Quote do
  def quote(region:, weight_grams:, subtotal_cents: 1000, tier: "standard")
    customer = create_customer(region:, tier:)
    order = create_order(customer:, items: {create_product(weight_grams:) => 1})
    described_class.new(order, subtotal_cents:).cents
  end

  {"CA" => 599, "NY" => 899, "TX" => 799, "WA" => 599, "AK" => 1299}.each do |region, base|
    [[400, 1], [1000, 1], [2500, 3]].each do |grams, kilos|
      it "charges #{base + kilos * 150} for #{grams}g to #{region}" do
        expect(quote(region:, weight_grams: grams)).to eq(base + kilos * 150)
      end
    end
  end

  it "ships free over $75" do
    expect(quote(region: "NY", weight_grams: 5000, subtotal_cents: 7500)).to eq(0)
  end

  it "ships free for gold customers" do
    expect(quote(region: "NY", weight_grams: 5000, tier: "gold")).to eq(0)
  end

  it "is free for an empty order" do
    expect(described_class.new(create_order, subtotal_cents: 0).cents).to eq(0)
  end
end
