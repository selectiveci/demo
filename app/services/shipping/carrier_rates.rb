module Shipping
  class CarrierRates
    SOURCE = Rails.root.join("config/carrier_rates.yml")
    SHEET_FETCH_SECONDS = 0.4

    def self.for(carrier)
      @tables ||= {}
      @tables[carrier] ||= fetch(carrier)
    end

    def self.price(table, weight_grams:)
      table.fetch("base_cents") + (weight_grams / 1000.0).ceil * table.fetch("per_kg_cents")
    end

    # Stands in for downloading the carrier's published rate sheet.
    def self.fetch(carrier)
      sleep(SHEET_FETCH_SECONDS)
      YAML.load_file(SOURCE).fetch(carrier)
    end
    private_class_method :fetch
  end
end
