module Pricing
  class Subtotal
    def self.for(order) = order.line_items.sum(&:total_cents)
  end
end
