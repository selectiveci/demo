module Reports
  class DailySales
    def initialize(date)
      @date = date
    end

    def orders = Order.where(status: %w[placed shipped], created_at: @date.all_day)

    def summary
      placed = orders.includes(line_items: :product).to_a
      {
        date: @date.iso8601,
        orders: placed.size,
        units: placed.sum(&:item_count),
        revenue_cents: placed.sum { |order| Pricing::Subtotal.for(order) },
        by_category: by_category(placed)
      }
    end

    private

    def by_category(orders)
      orders.flat_map(&:line_items).group_by { |item| item.product.category }
        .transform_values { |items| items.sum(&:total_cents) }
        .sort.to_h
    end
  end
end
