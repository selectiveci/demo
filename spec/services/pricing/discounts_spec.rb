RSpec.describe Pricing::Discounts do
  def discount(coupon_code, items)
    described_class.new(create_order(coupon_code:, items:)).cents
  end

  it "is zero without a coupon" do
    expect(discount(nil, {create_product => 1})).to eq(0)
  end

  it "is zero for an unknown coupon" do
    expect(discount("BOGUS", {create_product => 1})).to eq(0)
  end

  it "ignores the coupon's case" do
    expect(discount("welcome10", {create_product(price_cents: 5000) => 1})).to eq(500)
  end

  [[1000, 100], [4999, 500], [12_345, 1234]].each do |price, expected|
    it "takes 10% off #{price} with WELCOME10" do
      expect(discount("WELCOME10", {create_product(price_cents: price) => 1})).to eq(expected)
    end
  end

  it "takes $5 off with SAVE5 at the minimum" do
    expect(discount("SAVE5", {create_product(price_cents: 2500) => 1})).to eq(500)
  end

  it "does not apply SAVE5 below the minimum" do
    expect(discount("SAVE5", {create_product(price_cents: 2499) => 1})).to eq(0)
  end

  it "applies BOOKWORM only to books" do
    items = {create_product(category: "books", price_cents: 2000) => 1, create_product(category: "electronics", price_cents: 9000) => 1}
    expect(discount("BOOKWORM", items)).to eq(400)
  end

  it "gives nothing with BOOKWORM and no books" do
    expect(discount("BOOKWORM", {create_product(category: "apparel") => 3})).to eq(0)
  end
end
