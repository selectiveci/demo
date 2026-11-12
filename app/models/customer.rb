class Customer < ApplicationRecord
  TIERS = %w[standard silver gold].freeze

  has_many :orders, dependent: :destroy

  validates :name, :email, :region, presence: true
  validates :email, uniqueness: true, format: {with: /\A[^@\s]+@[^@\s]+\z/}
  validates :tier, inclusion: {in: TIERS}

  def gold? = tier == "gold"
end
