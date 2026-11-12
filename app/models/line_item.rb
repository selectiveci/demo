class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: {greater_than: 0}

  def total_cents = unit_price_cents * quantity
end
