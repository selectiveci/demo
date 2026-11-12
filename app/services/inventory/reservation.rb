module Inventory
  class Reservation
    class OutOfStock < StandardError; end

    def initialize(order)
      @order = order
    end

    def reserve!
      Product.transaction do
        @order.line_items.includes(:product).each do |item|
          product = item.product.lock!
          raise OutOfStock, product.sku unless product.in_stock?(item.quantity)

          product.update!(stock: product.stock - item.quantity)
        end
      end
    end
  end
end
