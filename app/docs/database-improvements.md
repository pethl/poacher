# Database Improvements

This document records database integrity improvements identified during the code review.

Changes are collected here and implemented together before production deployment. This avoids creating numerous small migrations during the review while ensuring the database enforces the same business rules as the Rails models.

When ready to implement, create a migration:

```bash
bin/rails generate migration ImproveDatabaseIntegrity
```

Then add the reviewed changes to that migration and run:

```bash
bin/rails db:migrate
```

---## TraceabilityRecord

### Unique traceability record per makesheet

**Reason**

The model validates that each Makesheet can only have one TraceabilityRecord. This should also be enforced by the database to prevent duplicate records under concurrent writes.

**Migration**

```ruby
remove_index :traceability_records, :makesheet_id
add_index :traceability_records, :makesheet_id, unique: true
```

Status: ☐ Complete

## TraceabilityRecord

### Store total batch weight as decimal

**Reason**

`total_weight_of_batch` is calculated from decimal individual cheese weights. The current integer column would discard decimal precision.

**Migration**

```ruby
change_column :traceability_records,
              :total_weight_of_batch,
              :decimal,
              precision: 8,
              scale: 2

Status: ☐ Complete

## WasteRecord

### One waste record per batch per day

**Reason**

The model permits only one WasteRecord for each combination of traceability record and waste date. The database should enforce the same rule.

**Migration**

```ruby
add_index :waste_records,
          %i[traceability_record_id waste_date],
          unique: true

Status: ☐ Pending

## Turn

### One turn per makesheet per date

**Reason**

A cheese batch should only be turned once on a given date. A second turn would reverse the first and defeat the purpose of the process.

**Migration**

```ruby
add_index :turns,
          %i[makesheet_id turn_date],
          unique: true