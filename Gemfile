source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.7"

# Framework and server
gem "rails", "~> 7.1.3"
gem "logger"
gem "puma", "~> 6.0"

# Database
gem "pg"

# Frontend and assets
gem "sprockets-rails"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "tailwindcss-rails", "~> 2.6"
gem "jbuilder"

# Authentication
gem "devise"

# Authorization
gem "cancancan"

# Charts and reporting
gem "chartkick"
gem "highcharts-rails"
gem "groupdate"

# PDF generation
gem "prawn", "~> 2.5"
gem "prawn-table", "~> 0.1.0"
gem "prawn-qrcode"

# QR code generation
gem "rqrcode"
gem "rqrcode_svg"
gem "barby"
gem "chunky_png"

# Data import
gem "roo", "~> 2.10.1"
gem "csv", "~> 3.3.2"
gem "activerecord-import"

# HTTP client
gem "httparty"

# Ruby compatibility
gem "bigdecimal", "~> 3.1", ">= 3.1.8"
gem "mutex_m", "~> 0.2.0"
gem "base64", "~> 0.2.0"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Performance
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "yard", "~> 0.9.37"
  gem "faker", "~> 3.2"
  gem "rspec-rails", "~> 6.1.0"
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "factory_bot_rails"
  gem "shoulda-matchers"
end

group :development do
  gem "web-console"
  gem "solargraph"
  gem "ruby-lsp"
  gem "letter_opener"
  gem "letter_opener_web"
end

group :test do
  gem "simplecov", require: false
  gem "capybara-email"
  gem "pdf-reader"
end
