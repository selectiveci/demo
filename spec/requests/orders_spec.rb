RSpec.describe "Orders" do
  let(:order) { create_order(customer: create_customer(region: "WA"), items: {create_product(price_cents: 2500, weight_grams: 1500, stock: 3) => 2}) }

  it "shows a quote" do
    get "/orders/#{order.id}"
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body).to include("status" => "cart", "subtotal" => "$50.00", "tax" => "$3.25", "shipping" => "$10.49", "total" => "$63.74")
  end

  it "returns 404 for a missing order" do
    get "/orders/0"
    expect(response).to have_http_status(:not_found)
  end

  it "places an order" do
    post "/orders/#{order.id}/place"
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body["status"]).to eq("placed")
  end

  it "refuses an order it cannot fill" do
    order.line_items.first.product.update!(stock: 1)
    post "/orders/#{order.id}/place"
    expect(response).to have_http_status(:conflict)
    expect(response.parsed_body["error"]).to eq("out_of_stock")
  end

  it "holds an order for review" do
    big = create_order(items: {create_product(price_cents: 120_000, stock: 5) => 1})
    post "/orders/#{big.id}/place"
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.parsed_body["reasons"]).to eq(["large_order"])
  end

  it "reports healthy" do
    get "/up"
    expect(response).to have_http_status(:ok)
  end
end
