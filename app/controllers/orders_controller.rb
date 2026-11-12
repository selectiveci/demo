class OrdersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }

  def show
    order = Order.find(params[:id])
    render json: receipt_json(order, Checkout.new(order).quote)
  end

  def place
    order = Order.find(params[:id])
    receipt = Checkout.new(order).place!
    render json: receipt_json(order.reload, receipt)
  rescue Checkout::Rejected => e
    render json: {error: "review", reasons: e.message.split(", ")}, status: :unprocessable_content
  rescue Inventory::Reservation::OutOfStock => e
    render json: {error: "out_of_stock", sku: e.message}, status: :conflict
  end

  private

  def receipt_json(order, receipt)
    {
      id: order.id,
      status: order.status,
      subtotal: Money.format(receipt.subtotal_cents),
      discount: Money.format(receipt.discount_cents),
      tax: Money.format(receipt.tax_cents),
      shipping: Money.format(receipt.shipping_cents),
      total: Money.format(receipt.total_cents)
    }
  end
end
