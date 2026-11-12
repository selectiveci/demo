class Product < ApplicationRecord
  CATEGORIES = %w[apparel books electronics grocery].freeze

  validates :name, :sku, presence: true
  validates :sku, uniqueness: true
  validates :category, inclusion: {in: CATEGORIES}
  validates :price_cents, numericality: {greater_than: 0}
  validates :stock, numericality: {greater_than_or_equal_to: 0}

  def in_stock?(quantity = 1) = stock >= quantity
end
