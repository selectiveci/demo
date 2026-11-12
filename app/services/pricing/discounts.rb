module Pricing
  class Discounts
    COUPONS = YAML.load_file(Rails.root.join("config/coupons.yml")).freeze

    def initialize(order)
      @order = order
    end

    def cents
      coupon = COUPONS[@order.coupon_code.to_s.upcase]
      return 0 unless coupon

      eligible = eligible_cents(coupon)
      return 0 if eligible < coupon.fetch("minimum_cents", 0)

      case coupon["kind"]
      when "percent" then Money.percent_of(eligible, coupon["amount"])
      when "fixed" then [coupon["amount"], eligible].min
      else 0
      end
    end

    private

    def eligible_cents(coupon)
      items = @order.line_items.includes(:product)
      items = items.select { |item| item.product.category == coupon["category"] } if coupon["category"]
      items.sum(&:total_cents)
    end
  end
end
