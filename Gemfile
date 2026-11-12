source "https://rubygems.org"

gem "rails", "~> 8.1.4", ">= 8.1.4.1"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rspec-rails", "~> 8.0"
end

group :test do
  gem "selective-ruby-rspec", require: false
end
