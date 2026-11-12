module Loyalty
  class Points
    MULTIPLIER = {"standard" => 1, "silver" => 2, "gold" => 4}.freeze

    def self.for(customer, spent_cents:)
      return 0 if spent_cents <= 0

      (spent_cents / 100) * MULTIPLIER.fetch(customer.tier)
    end

    def self.redeemable_cents(points) = (points / 100) * 100
  end
end
