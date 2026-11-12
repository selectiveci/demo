RSpec.describe Reports::DailySales do
  let(:today) { Date.new(2026, 11, 12) }

  def placed_order(items, status: "placed", at: today.noon)
    create_order(items:, status:, created_at: at)
  end

  it "is empty on a quiet day" do
    expect(described_class.new(today).summary).to include(orders: 0, units: 0, revenue_cents: 0, by_category: {})
  end

  it "counts placed and shipped orders" do
    placed_order({create_product => 1})
    placed_order({create_product => 1}, status: "shipped")
    expect(described_class.new(today).summary[:orders]).to eq(2)
  end

  %w[cart cancelled].each do |status|
    it "ignores #{status} orders" do
      placed_order({create_product => 1}, status:)
      expect(described_class.new(today).summary[:orders]).to eq(0)
    end
  end

  it "ignores other days" do
    placed_order({create_product => 1}, at: today.prev_day.noon)
    expect(described_class.new(today).summary[:orders]).to eq(0)
  end

  it "adds up units and revenue" do
    placed_order({create_product(price_cents: 1000) => 3})
    placed_order({create_product(price_cents: 250) => 2})
    expect(described_class.new(today).summary).to include(units: 5, revenue_cents: 3500)
  end

  it "breaks revenue down by category" do
    placed_order({create_product(category: "books", price_cents: 1500) => 1, create_product(category: "apparel", price_cents: 4000) => 1})
    expect(described_class.new(today).summary[:by_category]).to eq("apparel" => 4000, "books" => 1500)
  end
end
