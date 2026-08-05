# POACHER

POACHER is an internal business operations application for a cheesemaking company.

It supports the production process from initial make through storage, ageing, washing, cutting and packaging. It also covers wholesale and consumer sales, management reporting, ingredient traceability, production observations, and health and safety testing.

## Users

The application is for internal staff only. It does not provide external customer access.

Primary users include:

- Cheesemakers
- Warehouse operators
- Washing and cutting room staff
- Office administrators
- Health and safety managers
- Management

## Technology Stack

| Area | Technology |
|---|---|
| Language | Ruby 3.3.7 |
| Web framework | Ruby on Rails 7.1 |
| Database | PostgreSQL |
| Web server | Puma |
| Frontend | Hotwire using Turbo and Stimulus |
| JavaScript bundling | jsbundling-rails |
| CSS bundling | cssbundling-rails |
| Styling | Tailwind CSS |
| Asset pipeline | Sprockets |
| Authentication | Devise |
| Charts and reporting | Chartkick, Highcharts and Groupdate |
| PDF generation | Prawn, Prawn Table and Prawn QR Code |
| QR and barcode generation | RQRCode, RQRCode SVG, Barby and ChunkyPNG |
| Spreadsheet and CSV import | Roo and CSV |
| Bulk data import | activerecord-import |
| External HTTP requests | HTTParty |
| Testing | RSpec, Capybara, Selenium, FactoryBot and Shoulda Matchers |
| Code coverage | SimpleCov |
| Developer documentation | YARD |
| Development tooling | Ruby LSP, Solargraph and Letter Opener |

## Requirements

The application requires:

- Ruby 3.3.7
- PostgreSQL
- Node.js
- Yarn or another supported JavaScript package manager

Additional requirements will be documented as the development setup is reviewed.

## Setup

Clone the repository and install the dependencies:

```bash
bundle install
```

Install JavaScript dependencies:

```bash
yarn install
```

Create and prepare the database:

```bash
bin/rails db:prepare
```

Any required environment variables or credentials should be configured before starting the application.

## Running the Application

Start the application using:

```bash
bin/dev
```

The application is normally available at:

```text
http://localhost:3000. (dev test only)
https://poacher-372c39400a05.herokuapp.com/users/sign_in
```

## Running the Tests

Run the test suite with:

```bash
bundle exec rspec
```

Run the test coverage report with:

```bash
COVERAGE=true bundle exec rspec
```

## Documentation

More detailed documentation will be added under the `docs/` directory as the application is reviewed.

Planned documentation includes:

- application architecture
- development setup
- business processes
- external integrations
- testing
- deployment and operations