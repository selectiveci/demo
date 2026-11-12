class Order < ApplicationRecord
  STATUSES = %w[cart placed shipped cancelled].freeze

  belongs_to :customer
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items

  validates :status, inclusion: {in: STATUSES}
  validates :ship_to_region, presence: true

  def add(product, quantity: 1)
    line_items.create!(product:, quantity:, unit_price_cents: product.price_cents)
  end

  def item_count = line_items.sum(:quantity)
  def weight_grams = line_items.includes(:product).sum { |item| item.product.weight_grams * item.quantity }
end
