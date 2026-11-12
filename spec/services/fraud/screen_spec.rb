RSpec.describe Fraud::Screen do
  def screen(total_cents:, quantity: 1, home: "CA", ship_to: "CA")
    order = create_order(customer: create_customer(region: home), ship_to_region: ship_to, items: {create_product(stock: 100) => quantity})
    described_class.new(order, total_cents:).call
  end

  it "approves an ordinary order" do
    expect(screen(total_cents: 5000)).to be_approved
  end

  it "reviews a large order" do
    expect(screen(total_cents: 100_000).reasons).to eq([:large_order])
  end

  it "reviews bulk quantities" do
    expect(screen(total_cents: 5000, quantity: 21).reasons).to eq([:bulk_quantity])
  end

  it "allows the bulk limit exactly" do
    expect(screen(total_cents: 5000, quantity: 20)).to be_approved
  end

  it "reviews a mid-size order shipped away from home" do
    expect(screen(total_cents: 60_000, ship_to: "NY").reasons).to eq([:region_mismatch])
  end

  it "approves a small order shipped away from home" do
    expect(screen(total_cents: 4000, ship_to: "NY")).to be_approved
  end

  it "collects every reason" do
    expect(screen(total_cents: 150_000, quantity: 30, ship_to: "TX").reasons)
      .to contain_exactly(:large_order, :bulk_quantity, :region_mismatch)
  end
end
