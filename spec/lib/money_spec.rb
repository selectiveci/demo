RSpec.describe Money do
  {
    0 => "$0.00", 5 => "$0.05", 99 => "$0.99", 100 => "$1.00", 1999 => "$19.99",
    100_000 => "$1,000.00", 123_456_789 => "$1,234,567.89", -250 => "-$2.50"
  }.each do |cents, formatted|
    it "formats #{cents} cents as #{formatted}" do
      expect(described_class.format(cents)).to eq(formatted)
    end
  end

  [[1000, 0.0725, 72], [1000, 0.065, 65], [250, 0.10, 25], [15, 0.5, 8], [25, 0.5, 12], [0, 0.2, 0]].each do |cents, rate, expected|
    it "takes #{rate} of #{cents} cents as #{expected}, rounding half to even" do
      expect(described_class.percent_of(cents, rate)).to eq(expected)
    end
  end
end
