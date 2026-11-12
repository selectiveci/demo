require "zlib"

# Gives each example a stable, realistic duration so the full suite takes about
# as long as a real one. Set DEMO_PACE=0 to run at full speed.
module Pacing
  SCALE = Float(ENV.fetch("DEMO_PACE", "1"))

  def self.seconds_for(example)
    (0.9 + (Zlib.crc32(example.id) % 1000) / 1000.0 * 1.2) * SCALE
  end
end

RSpec.configure do |config|
  config.after { |example| sleep(Pacing.seconds_for(example)) }
end
