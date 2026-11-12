RSpec.describe Product do
  Product::CATEGORIES.each do |category|
    it "accepts the #{category} category" do
      expect(create_product(category:)).to be_persisted
    end
  end

  it "rejects an unknown category" do
    expect(described_class.new(name: "X", sku: "X", category: "toys", price_cents: 100)).not_to be_valid
  end

  [0, -100].each do |price|
    it "rejects a price of #{price}" do
      expect(described_class.new(name: "X", sku: "X", category: "books", price_cents: price)).not_to be_valid
    end
  end

  it "rejects negative stock" do
    expect(described_class.new(name: "X", sku: "X", category: "books", price_cents: 100, stock: -1)).not_to be_valid
  end

  it "requires a unique sku" do
    create_product(sku: "BOOK-1")
    expect(described_class.new(name: "X", sku: "BOOK-1", category: "books", price_cents: 100)).not_to be_valid
  end

  {1 => true, 5 => true, 6 => false}.each do |quantity, expected|
    it "reports in_stock?(#{quantity}) as #{expected} with 5 on hand" do
      expect(create_product(stock: 5).in_stock?(quantity)).to eq(expected)
    end
  end
end
