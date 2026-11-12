module Notifications
  class OrderConfirmation
    def initialize(order, receipt)
      @order = order
      @receipt = receipt
    end

    def subject = "Order ##{@order.id} confirmed"

    def body
      first_name = @order.customer.name.split.first
      items = @order.item_count
      "Hi #{first_name}, thanks for your order of #{items} #{"item".pluralize(items)}. " \
        "Your total was #{Money.format(@receipt.total_cents)}."
    end
  end
end
