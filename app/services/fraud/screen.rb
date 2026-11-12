module Fraud
  class Screen
    LARGE_ORDER_CENTS = 100_000
    MAX_UNITS_PER_SKU = 20

    Result = Data.define(:status, :reasons) do
      def approved? = status == :approved
    end

    def initialize(order, total_cents:)
      @order = order
      @total_cents = total_cents
    end

    def call
      reasons = []
      reasons << :large_order if @total_cents >= LARGE_ORDER_CENTS
      reasons << :bulk_quantity if @order.line_items.any? { |item| item.quantity > MAX_UNITS_PER_SKU }
      reasons << :region_mismatch if @order.customer.region != @order.ship_to_region && @total_cents >= LARGE_ORDER_CENTS / 2

      Result.new(status: reasons.empty? ? :approved : :review, reasons:)
    end
  end
end
