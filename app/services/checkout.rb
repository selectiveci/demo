class Checkout
  Receipt = Data.define(:subtotal_cents, :discount_cents, :tax_cents, :shipping_cents, :total_cents, :screening)

  class Rejected < StandardError; end

  def initialize(order)
    @order = order
  end

  def quote
    subtotal = Pricing::Subtotal.for(@order)
    discount = Pricing::Discounts.new(@order).cents
    tax = Pricing::Tax.new(@order).cents
    shipping = Shipping::Quote.new(@order, subtotal_cents: subtotal - discount).cents
    total = subtotal - discount + tax + shipping

    Receipt.new(subtotal_cents: subtotal, discount_cents: discount, tax_cents: tax,
      shipping_cents: shipping, total_cents: total,
      screening: Fraud::Screen.new(@order, total_cents: total).call)
  end

  def place!
    receipt = quote
    raise Rejected, receipt.screening.reasons.join(", ") unless receipt.screening.approved?

    Inventory::Reservation.new(@order).reserve!
    @order.update!(status: "placed")
    receipt
  end
end
