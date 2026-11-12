module Invoices
  class Renderer
    TEMPLATE = Rails.root.join("app/views/invoices/invoice.text.erb")

    def initialize(order, receipt)
      @order = order
      @receipt = receipt
    end

    def render
      ERB.new(File.read(TEMPLATE), trim_mode: "-").result(binding)
    end

    private

    def money(cents) = Money.format(cents)
  end
end
