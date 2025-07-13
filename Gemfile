source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.7"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
#gem "rails", "~> 7.0.8", ">= 7.0.8.4"
gem 'rails', '~> 7.1.3'  # or latest stable
gem 'logger'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
#gem "sqlite3", "~> 1.4"
gem "pg"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'yard', '~> 0.9.37'
  gem 'faker', '~> 3.2'
  gem 'rspec-rails', '~> 6.1.0'
  gem 'capybara'
  gem 'selenium-webdriver' # for browser testing
  gem 'webdrivers' 
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
end
 

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  # for prettier
  gem "solargraph"
  gem 'ruby-lsp'
  gem 'letter_opener'
  gem 'letter_opener_web', group: :development

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  #for weather app env management
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  #gem "capybara"
 # gem "selenium-webdriver"
 gem 'simplecov', require: false
 gem 'capybara-email'

end

# for devise
gem "devise"

# required after 3.3.4 upgrade, may be able to remove eventuallybu
gem "bigdecimal", "~> 3.1", ">= 3.1.8"
gem "mutex_m", "~> 0.2.0"
gem "base64", "~> 0.2.0"

gem "tailwindcss-rails", "~> 2.6"
gem "chartkick"
gem "highcharts-rails"
gem "groupdate"

# PDF generator
gem "prawn", "~> 2.5"
gem "prawn-table", "~> 0.1.0"

# for Excel imports
gem "roo", "~> 2.10.1"
gem "csv", "~> 3.3.2"

#for weather
gem 'httparty'

#for samples import
gem 'activerecord-import'

# QR generation
gem 'rqrcode'          # Core QR generation
gem 'barby'
gem 'chunky_png'

# HTML support
gem 'rqrcode_svg'      # For rendering SVGs in HTML views

# PDF support
gem 'prawn-qrcode'     # For rendering QR codes in Prawn PDFs


