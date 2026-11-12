ActiveRecord::Schema[8.1].define(version: 2026_11_01_000004) do
  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "tier", null: false, default: "standard"
    t.string "region", null: false
    t.timestamps
    t.index ["email"], unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "sku", null: false
    t.string "category", null: false
    t.integer "price_cents", null: false
    t.integer "weight_grams", null: false, default: 0
    t.integer "stock", null: false, default: 0
    t.timestamps
    t.index ["sku"], unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.references "customer", null: false, foreign_key: true
    t.string "status", null: false, default: "cart"
    t.string "coupon_code"
    t.string "ship_to_region", null: false
    t.timestamps
  end

  create_table "line_items", force: :cascade do |t|
    t.references "order", null: false, foreign_key: true
    t.references "product", null: false, foreign_key: true
    t.integer "quantity", null: false, default: 1
    t.integer "unit_price_cents", null: false
    t.timestamps
  end
end
