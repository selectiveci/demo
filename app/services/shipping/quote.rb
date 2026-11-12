module Shipping
  class Quote
    BASE_CENTS = {"CA" => 599, "OR" => 599, "WA" => 599, "NY" => 899, "TX" => 799}.freeze
    PER_KG_CENTS = 150
    FREE_OVER_CENTS = 7500

    def initialize(order, subtotal_cents:)
      @order = order
      @subtotal_cents = subtotal_cents
    end

    def cents
      return 0 if @order.line_items.empty?
      return 0 if @subtotal_cents >= FREE_OVER_CENTS
      return 0 if @order.customer.gold?

      base = BASE_CENTS.fetch(@order.ship_to_region, 1299)
      base + (@order.weight_grams / 1000.0).ceil * PER_KG_CENTS
    end
  end
end
