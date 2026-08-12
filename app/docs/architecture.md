# Architecture

## Overview

POACHER is an internal business operations application used to manage the complete lifecycle of cheese production, storage, processing and sales.

The application supports business operations from the recording of production ("makes"), through storage and maturation, washing, cutting and packaging, to customer sales and operational reporting. It also provides traceability of ingredients and batches together with health and safety recording.

The application is intended for use by employees of the business and is not customer-facing.

---

## Business Capabilities

The application is organised around the following business functions:

- Milk and ingredient management
- Cheese production (makes)
- Storage and ageing
- Warehouse management
- Cheese washing
- Cutting and packaging
- Customer and sales management
- Health and safety testing
- Reporting and management information
- System administration

These capabilities describe the business processes supported by the application rather than the underlying Rails structure.

---

## Technology

POACHER is built using Ruby on Rails with a PostgreSQL database and a Hotwire frontend.

The application uses:

- Ruby 3.3
- Rails 7.1
- PostgreSQL
- Puma
- Hotwire (Turbo and Stimulus)
- Tailwind CSS
- Devise for authentication
- RSpec for automated testing

Additional libraries provide support for reporting, PDF generation, charting, spreadsheet import and QR/barcode generation.

---

## High-Level Architecture

At a high level, the system consists of:

```text
Users
   │
   ▼
Ruby on Rails Application
   │
   ├── PostgreSQL Database
   ├── Reporting
   ├── PDF Generation
   ├── Import/Export
   └── External Services
```

As the project documentation develops, this section will be expanded with component and deployment diagrams.

---

## Authentication and Authorization

The application uses Devise for authentication (who you are) and CanCanCan for authorization
(what you can do).

Rather than hand-writing permission rules in code, access is defined as data: a `Group` ↔
`Membership` ↔ `User` structure, plus `GroupPermission` rows that grant a group a specific
action on a specific resource. A single `Ability` class (`app/models/ability.rb`) reads that
data at request time and builds the actual CanCanCan rules, caching each group's permissions
for an hour and busting the cache whenever a `GroupPermission` row changes.

Two kinds of group exist:

- **Blanket groups** (Admin, Mgmt) — full access to business data. Admin additionally manages
  the authorization system itself (Users, Groups, permission rows); Mgmt does not.
- **Bounded groups** (Office, H&S, Dairy, Store, Cutting) — each granted specific actions on
  specific models via `GroupPermission` rows, defined in `db/seeds/authorization.rb`. A user
  can belong to more than one group; their access is the union of all of them.

Every model that can be permission-gated is whitelisted in
`app/models/concerns/permission_registry.rb`, along with the allowed actions (`manage`,
`read`, plus narrower custom actions like `print_labels`, `link`, and `assign_location` for
cases that don't fit a plain CRUD split). Controllers enforce this via `authorize!` calls —
see `app/docs/auth_models.md` for the full rollout checklist of which controllers enforce
which rules.

---

## Primary Business Flow

The core operational flow through the application is:

```text
Milk & Ingredients
        │
        ▼
Cheese Production (Makes)
        │
        ▼
Storage & Ageing
        │
        ▼
Cheese Washing
        │
        ▼
Cutting & Packaging
        │
        ▼
Customer Sales
        │
        ▼
Reporting & Traceability
```


---

## Repository Structure

The application follows a conventional Ruby on Rails structure.

As the review progresses, this document will describe the major components of the codebase, including:

- domain models
- controllers
- services
- background processing
- reporting
- integrations
- supporting libraries

---

## Future Documentation

This architecture document provides a high-level overview only.

More detailed documentation will be added during the code review, including:

- Domain model
- Request and workflow diagrams
- Background processing
- Reporting architecture
- External integrations
- Deployment and operational considerations
- Architectural decisions

Level 2
## Core Domain Structure

The application is organised around several central business domains.

### Production

The Makesheet model is the central production record.

It coordinates:

- Traceability
- Batch Weights
- Turns
- Washing
- Grading
- Samples
- Ingredient Batch Changes

### Traceability

Ingredient traceability is achieved through the relationship:

Makesheet
→ IngredientBatchChange
→ DeliveryInspection

This allows a production batch to record changes in ingredient batches during manufacture.

### Order Fulfilment

Customer orders are represented by Picksheets which contain PicksheetItems linked back to Makesheets where traceability is required.

...

## Design Principles

The following principles have guided the design of POACHER:

- Automate repetitive administrative tasks where they reduce effort without compromising quality.
- Keep food safety and production decisions under human control.
- Prioritise traceability and auditability over convenience.
- Optimise workflows for a small internal team rather than high transaction volumes.
- Record operational events as close as possible to when they occur.