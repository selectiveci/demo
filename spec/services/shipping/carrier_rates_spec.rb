require "benchmark"

RSpec.describe Shipping::CarrierRates do
  %w[ground express freight].each do |carrier|
    it "quotes #{carrier} within the 250ms checkout budget" do
      elapsed = Benchmark.realtime { described_class.price(described_class.for(carrier), weight_grams: 1200) }
      expect(elapsed).to be < 0.25
    end
  end

  let(:table) { {"base_cents" => 500, "per_kg_cents" => 100} }

  [[0, 500], [1, 600], [1000, 600], [1001, 700], [12_500, 1800]].each do |grams, cents|
    it "prices #{grams}g at #{cents} cents" do
      expect(described_class.price(table, weight_grams: grams)).to eq(cents)
    end
  end
end
