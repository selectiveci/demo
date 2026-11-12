RSpec.describe Customer do
  it "is valid with the defaults" do
    expect(create_customer).to be_persisted
  end

  %i[name email region].each do |attr|
    it "requires #{attr}" do
      customer = described_class.new(name: "A", email: "a@example.com", region: "CA").tap { |c| c[attr] = nil }
      expect(customer).not_to be_valid
      expect(customer.errors[attr]).to be_present
    end
  end

  %w[standard silver gold].each do |tier|
    it "accepts the #{tier} tier" do
      expect(create_customer(tier:).tier).to eq(tier)
    end
  end

  it "rejects an unknown tier" do
    expect(described_class.new(name: "A", email: "a@example.com", region: "CA", tier: "platinum")).not_to be_valid
  end

  ["no-at-sign", "two@@example.com", "spaces in@example.com"].each do |email|
    it "rejects the malformed email #{email.inspect}" do
      expect(described_class.new(name: "A", email:, region: "CA")).not_to be_valid
    end
  end

  it "rejects a duplicate email" do
    create_customer(email: "dup@example.com")
    expect(described_class.new(name: "B", email: "dup@example.com", region: "CA")).not_to be_valid
  end

  it "knows a gold customer" do
    expect(create_customer(tier: "gold")).to be_gold
    expect(create_customer(tier: "silver")).not_to be_gold
  end
end
