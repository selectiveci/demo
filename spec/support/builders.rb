module Builders
  def create_customer(**attrs)
    n = next_seq
    Customer.create!({name: "Ada Lovelace", email: "ada#{n}@example.com", tier: "standard", region: "CA"}.merge(attrs))
  end

  def create_product(**attrs)
    n = next_seq
    Product.create!({name: "Widget #{n}", sku: "SKU-#{n}", category: "electronics", price_cents: 1000, weight_grams: 500, stock: 10}.merge(attrs))
  end

  def create_order(customer: create_customer, items: {}, **attrs)
    order = Order.create!({customer:, ship_to_region: customer.region}.merge(attrs))
    items.each { |product, quantity| order.add(product, quantity:) }
    order
  end

  private

  def next_seq = (@seq = (@seq || 0) + 1) + rand(1_000_000) * 1000
end
