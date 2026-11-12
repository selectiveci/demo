module Pricing
  class Tax
    RATES = YAML.load_file(Rails.root.join("config/tax_rates.yml")).freeze

    def self.rate(region, category)
      rates = RATES.fetch(region) { return 0.0 }
      rates.fetch(category) { rates.fetch("default") }
    end

    def initialize(order)
      @order = order
    end

    def cents
      @order.line_items.includes(:product).sum do |item|
        Money.percent_of(item.total_cents, self.class.rate(@order.ship_to_region, item.product.category))
      end
    end
  end
end
