RSpec.describe Inventory::Reservation do
  it "takes the ordered quantity out of stock" do
    product = create_product(stock: 5)
    described_class.new(create_order(items: {product => 2})).reserve!
    expect(product.reload.stock).to eq(3)
  end

  it "can take the last unit" do
    product = create_product(stock: 1)
    described_class.new(create_order(items: {product => 1})).reserve!
    expect(product.reload.stock).to eq(0)
  end

  it "refuses when a product is short" do
    product = create_product(stock: 1, sku: "LAST-ONE")
    expect { described_class.new(create_order(items: {product => 2})).reserve! }
      .to raise_error(described_class::OutOfStock, "LAST-ONE")
  end

  it "reserves nothing when any line is short" do
    plenty = create_product(stock: 10)
    short = create_product(stock: 0)
    reservation = described_class.new(create_order(items: {plenty => 1, short => 1}))
    expect { reservation.reserve! }.to raise_error(described_class::OutOfStock)
    expect(plenty.reload.stock).to eq(10)
  end
end
