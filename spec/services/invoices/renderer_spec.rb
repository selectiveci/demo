RSpec.describe Invoices::Renderer do
  let(:customer) { create_customer(name: "Grace Hopper", email: "grace@example.com", region: "TX") }

  def render(coupon_code: nil, items: {create_product(name: "Compiler", sku: "CMP-1", price_cents: 4500) => 2})
    order = create_order(customer:, coupon_code:, items:)
    described_class.new(order, Checkout.new(order).quote).render
  end

  it "addresses the customer" do
    expect(render).to include("Bill to: Grace Hopper <grace@example.com>")
  end

  it "lists each line" do
    expect(render).to include("2 x Compiler (CMP-1)  $90.00")
  end

  it "shows tax" do
    expect(render).to include("Tax:      $5.62")
  end

  it "shows free shipping" do
    expect(render).to include("Shipping: FREE")
  end

  it "shows a discount when there is one" do
    expect(render(coupon_code: "WELCOME10")).to include("Discount: -$9.00")
  end

  it "leaves out the discount line when there is none" do
    expect(render).not_to include("Discount")
  end

  it "totals the order" do
    expect(render).to include("Total:    $95.62")
  end
end
