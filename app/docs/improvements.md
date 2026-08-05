# Improvements

This document captures potential improvements identified during the review of the POACHER codebase.

The aim is to record ideas while reviewing the code so they are not forgotten. Recording an item here does **not** necessarily mean it should be changed immediately. Many items exist simply to prompt future investigation.

## Priority Guide

- ⬜ Critical – Bug, security issue or risk of data loss.
- 🟧 High – Significant maintainability or correctness improvement.
- 🟨 Medium – Worth improving when working in the area.
- 🟩 Low – Code quality or consistency improvement.
- ❓ Investigate – Confirm the current behaviour before making any changes.

---

# Makesheet

## Associations

- [ ] ❓ Review the deletion behaviour of `turns`, `traceability_records` and `batch_weights`.
  - These associations do not currently specify a `dependent:` option.
  - Confirm whether child records should be retained, deleted, or prevent deletion of a makesheet.

---

## Business Rules

- [ ] ❓ Confirm that only one makesheet is permitted per production date.
  - The model enforces uniqueness on `make_date`.
  - Verify this matches the real production process.

- [ ] ❓ Document all permitted makesheet status values.
  - The model references `Created` and `Finished`.
  - Identify every valid status and the permitted workflow transitions.

---

## Code Quality

- [ ] 🟨 Simplify the `progress` method.
  - Reduce nested conditionals.
  - Consider using guard clauses or extracting smaller methods.
  - Ensure behaviour remains unchanged.

- [ ] 🟩 Standardise presence checks.
  - The model currently mixes `present?` with Active Record predicate methods such as `third_cut_time?`.
  - Adopt one consistent style.

- [ ] 🟩 Remove duplicate formatting methods.
  - Review methods such as:
    - `make_date_formatted_and_grade`
    - `make_date_formatted_batch_grade`
  - Consolidate where possible.

---

## Validation

- [ ] 🟧 Review `ValidationRange` usage.
  - The validation currently loads every active validation range.
  - Confirm that validation should instead be filtered by `target_model`.

- [ ] 🟨 Review validation error reporting.
  - Errors are currently added to `:base`.
  - Consider attaching errors directly to the affected field where appropriate.

---

## Presentation

- [ ] 🟨 Remove HTML generation from the model.
  - `flags` currently returns HTML links using `html_safe`.
  - Consider returning structured data and rendering HTML within the view or a presenter.

---

## Associations

- [ ] 🟨 Review the relationship between `CleaningForeignBodyCheck` and `Makesheet`.
  - The current implementation links records using matching dates.
  - Determine whether an explicit association would make the relationship clearer.

---

## Calculations

- [ ] 🟩 Review repeated age calculation methods.
  - `age_in_days`
  - `age_in_weeks`
  - `age_in_months`
  - Consider extracting common logic if it improves readability.

- [ ] 🟩 Review repeated date formatting methods.
  - Several helper methods generate slightly different date strings.
  - Consider consolidating them if they serve the same purpose.

---

# General

## Models

- [ ] 🟨 Review whether presentation logic belongs inside models.
- [ ] 🟨 Review whether large models should have calculations extracted into service objects where appropriate.
- [ ] 🟨 Review opportunities to reduce duplicated formatting code.
- [ ] 🟨 Review opportunities to improve test coverage around business calculations.

---

## Documentation

- [ ] Continue documenting the domain model as each business area is reviewed.
- [ ] Add workflow diagrams for the main production lifecycle.
- [ ] Document status transitions for each major process.
- [ ] Record important architectural decisions as they are made.

---

## Notes

Items should only be removed from this document when:

- they have been implemented,
- they have been intentionally rejected, or
- they are no longer relevant.



## Delivery Inspection / Ingredient Batch Change

- [ ] Replace `dependent: :nullify` on `DeliveryInspection` because `delivery_inspection_id` cannot be null.
- [ ] Review best-before validation; comparing with `Date.current` may block edits to historical records.
- [ ] Confirm whether `timely_delivery` and `apply_hold` require explicit true/false values.
- [ ] Review `backfill_makesheet_text`; it overwrites the legacy field when multiple batch changes exist.
- [ ] Confirm whether `item` needs to be duplicated on `IngredientBatchChange`.


## Milk Quality Monitor

- [ ] Confirm whether every milk-quality result must be linked to a makesheet; the association currently allows no makesheet.
- [ ] Enforce duplicate protection consistently. CSV import skips duplicate `sample_date` and `makesheet_id` combinations, but manual creation does not.
- [ ] Record why imported rows were skipped instead of treating invalid rows and duplicates identically.
- [ ] Identify and document where hold, flag and release decisions are stored and enforced.
- [ ] Add tests for CSV import and the rolling Bactoscan geometric average.

## Sample

- [ ] Add a database unique index for `sample_no`; model validation alone does not prevent duplicate records under concurrent imports.
- [ ] Correct sample import counts so existing sample numbers are reported as skipped rather than imported.
- [ ] Report rejected or invalid rows instead of always returning `rejected_count: 0`.
- [ ] Decide whether re-importing a sample should ignore it or update its results.
- [ ] Add tests for CSV, Excel, duplicate samples and unsupported file types.
- [ ] Move the large laboratory-column mapping into a constant or dedicated importer to make it easier to maintain.

## Traceability Record

- [x] Simplify the repeated waste-total methods by summing through the `waste_records` association.
- [x] Extract the 35 individual cheese-weight fields into one reusable helper method to remove duplicated field lists.
- [x] Add tests for calculated cheese count, calculated total weight and total waste.
- [ ] Store `total_weight_of_batch` as a calculated value from the individual cheese weights.
  - Pending decimal column migration and model callback.
- [x] Prevent deletion of a traceability record when waste records exist.

## Waste Record
- [ ] Add a unique database index on [traceability_record_id, waste_date].

## Batch Weight

- [ ] Restrict editing of saved BatchWeight records to authorised management users.
- [ ] Remove BatchWeight deletion from the user interface and routes.
- [ ] Add tests confirming that creating a BatchWeight marks the Makesheet as `Finished`.
- [ ] Confirm whether deleting or reversing a BatchWeight should ever reopen a Makesheet.
- [ ] Review overlap between BatchWeight and TraceabilityRecord reporting.

## Batch Weight - URGENT
- [ ] Add a management trend report showing waste percentage over time by cheese type.
  - Use the BatchWeight date for the timeline.
  - Group records by the linked Makesheet `make_type`.
  - Allow filtering by date range and cheese type.
  - Consider showing both individual batch results and a monthly rolling average.