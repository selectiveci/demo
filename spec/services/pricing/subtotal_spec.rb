RSpec.describe Pricing::Subtotal do
  it "is zero for an empty order" do
    expect(described_class.for(create_order)).to eq(0)
  end

  it "adds every line" do
    order = create_order(items: {create_product(price_cents: 1000) => 2, create_product(price_cents: 350) => 1})
    expect(described_class.for(order)).to eq(2350)
  end

  it "uses the price captured on the line, not the current price" do
    product = create_product(price_cents: 1000)
    order = create_order(items: {product => 1})
    product.update!(price_cents: 5000)
    expect(described_class.for(order.reload)).to eq(1000)
  end
end
