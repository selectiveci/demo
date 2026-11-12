RSpec.describe LineItem do
  [[1, 500, 500], [3, 1999, 5997], [10, 1, 10]].each do |quantity, price, total|
    it "totals #{quantity} x #{price} as #{total}" do
      expect(described_class.new(quantity:, unit_price_cents: price).total_cents).to eq(total)
    end
  end

  it "rejects a zero quantity" do
    expect(described_class.new(order: create_order, product: create_product, quantity: 0, unit_price_cents: 1)).not_to be_valid
  end
end
