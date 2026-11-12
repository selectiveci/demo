RSpec.describe Notifications::OrderConfirmation do
  def confirmation(quantity:)
    order = create_order(customer: create_customer(name: "Katherine Johnson", region: "OR"), items: {create_product(price_cents: 1250) => quantity})
    described_class.new(order, Checkout.new(order).quote)
  end

  it "puts the order number in the subject" do
    message = confirmation(quantity: 1)
    expect(message.subject).to match(/\AOrder #\d+ confirmed\z/)
  end

  it "greets the customer by first name" do
    expect(confirmation(quantity: 1).body).to start_with("Hi Katherine,")
  end

  {1 => "1 item", 2 => "2 items", 7 => "7 items"}.each do |quantity, phrase|
    it "says #{phrase}" do
      expect(confirmation(quantity:).body).to include("your order of #{phrase}.")
    end
  end

  it "states the total" do
    expect(confirmation(quantity: 2).body).to end_with("Your total was $32.49.")
  end
end
