RSpec.describe Order do
  it "starts as a cart" do
    expect(create_order.status).to eq("cart")
  end

  it "rejects an unknown status" do
    order = create_order
    order.status = "lost"
    expect(order).not_to be_valid
  end

  it "requires a ship-to region" do
    expect(described_class.new(customer: create_customer, ship_to_region: nil)).not_to be_valid
  end

  it "captures the product price when an item is added" do
    product = create_product(price_cents: 1999)
    item = create_order.add(product, quantity: 2)
    product.update!(price_cents: 2999)
    expect(item.reload.unit_price_cents).to eq(1999)
  end

  [[1], [2, 3], [1, 1, 1, 4]].each do |quantities|
    it "counts #{quantities.sum} items across #{quantities.size} lines" do
      order = create_order(items: quantities.to_h { |q| [create_product, q] })
      expect(order.item_count).to eq(quantities.sum)
    end
  end

  it "sums the shipping weight of every unit" do
    order = create_order(items: {create_product(weight_grams: 250) => 2, create_product(weight_grams: 1200) => 1})
    expect(order.weight_grams).to eq(1700)
  end

  it "removes its line items when destroyed" do
    order = create_order(items: {create_product => 1})
    expect { order.destroy }.to change(LineItem, :count).by(-1)
  end
end
