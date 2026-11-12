RSpec.describe Checkout do
  def order_for(region:, tier: "standard", coupon_code: nil, items: nil)
    customer = create_customer(region:, tier:)
    items ||= {create_product(price_cents: 2000, weight_grams: 800, category: "electronics") => 2}
    create_order(customer:, coupon_code:, items:)
  end

  {
    "CA" => {tax: 290, shipping: 899}, "NY" => {tax: 160, shipping: 1199},
    "TX" => {tax: 250, shipping: 1099}, "OR" => {tax: 0, shipping: 899}
  }.each do |region, expected|
    it "quotes a two-item order to #{region}" do
      receipt = described_class.new(order_for(region:)).quote
      expect(receipt).to have_attributes(subtotal_cents: 4000, discount_cents: 0, tax_cents: expected[:tax], shipping_cents: expected[:shipping])
      expect(receipt.total_cents).to eq(4000 + expected[:tax] + expected[:shipping])
    end
  end

  it "applies a coupon before shipping thresholds" do
    items = {create_product(price_cents: 8000, weight_grams: 100) => 1}
    receipt = described_class.new(order_for(region: "OR", coupon_code: "WELCOME10", items:)).quote
    expect(receipt).to have_attributes(discount_cents: 800, shipping_cents: 749, total_cents: 7949)
  end

  it "ships free for gold customers" do
    expect(described_class.new(order_for(region: "NY", tier: "gold")).quote.shipping_cents).to eq(0)
  end

  it "places an approved order" do
    order = order_for(region: "CA")
    described_class.new(order).place!
    expect(order.reload.status).to eq("placed")
  end

  it "reserves stock when it places an order" do
    product = create_product(stock: 4)
    described_class.new(order_for(region: "CA", items: {product => 3})).place!
    expect(product.reload.stock).to eq(1)
  end

  it "rejects an order that needs review" do
    order = order_for(region: "CA", items: {create_product(price_cents: 60_000, stock: 5) => 2})
    expect { described_class.new(order).place! }.to raise_error(described_class::Rejected, "large_order")
    expect(order.reload.status).to eq("cart")
  end
end
