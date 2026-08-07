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
- [x] Add a management trend report showing waste percentage over time by cheese type.
  - Use the BatchWeight date for the timeline.
  - Group records by the linked Makesheet `make_type`.
  - Allow filtering by date range and cheese type.
  - Consider showing both individual batch results and a monthly rolling average.
  ## IMPLEMENTATION
  Implemented the management waste trend report using the app’s existing Chartkick/Chart.js stack—no new gems required.
    Key features:
    Uses BatchWeight.date.
    Calculates waste as total_waste / washed_batch_weight × 100.
    Filters by 3, 6, 9, or 12 months.
    Filters/groups by Makesheet.make_type.
    Plots individual batches plus trailing three-calendar-month averages.
    Excludes incomplete measurements and zero washed weights.
    Accessible from Batch Weights, Cutting Room, and Management pages.
    New route: /batch_weights/waste_trend.
    Main changes:
    [BatchWeight model](/Users/pethickl/Documents/rails/poacher/app/models/batch_weight.rb)
    [BatchWeights controller](/Users/pethickl/Documents/rails/poacher/app/controllers/batch_weights_controller.rb)
    [Waste trend view](/Users/pethickl/Documents/rails/poacher/app/views/batch_weights/waste_trend.html.erb)
    [Routes](/Users/pethickl/Documents/rails/poacher/config/routes.rb)
    [Request spec](/Users/pethickl/Documents/rails/poacher/spec/requests/batch_weights_waste_trend_spec.rb)
    Verification: 14 focused model/request examples pass with zero failures. The focused run still triggers the project’s global 70% SimpleCov threshold, as expected when running only two spec files. Existing unrelated working-tree changes were preserved.

  ## Contact

- [x] Confirm whether Contact represents customers only or also suppliers and other business contacts.
- [x] Add validation requiring a business name.
- [x] Add tests for payment terms and the rule allowing only one payment term.
- [x] Review deletion behaviour for Contacts linked to Picksheets or Makesheets.

## Cheese Wash Record

- [ ] Flag wash records where `remaining_to_wash` is zero but `date_batch_finished` is blank.
  - Show the warning on the index.
  - Prompt staff to enter the finish date.
  - Do not auto-finish the record, as the finish date should still be confirmed by a user.

  ## Turn

- [x] Rename `date_and_grade` to `date_and_batch` so the name matches its output.
- [x] Confirm the permitted values and meaning of `turned_by`.
- [x] Confirm whether more than one turn can be recorded for the same makesheet and date.
- [x] Confirm deletion rules for maturation records.
  - Turn records should not be deleted through the normal user interface.
  - Corrections should be made by editing the record.
  - Older turn records may later be archived or removed under an agreed retention policy once the related cheese has been sold.
  - Any archival process should preserve enough summary information for traceability and reporting.
  - [ ] Define a retention and archiving policy for historic turn records.
  - Decide how long detailed turn history must be retained.
  - Confirm whether sold batches still require full turn-level traceability.
  - Consider archiving old records before physical deletion.
  - Ensure any cleanup process is auditable and restricted to authorised management.

  ## Makesheet

- [ ] Add a `turnable` scope to return batches that are still in maturation and available for turning.
- [ ] Replace `Makesheet.all.order(:make_date)` in `TurnsController` with the new scope.

## User

- [x] Add department information to User when Staff is retired.
- [ ] Add a scope for active Cheese Store users.
- [ ] Restrict the Turn `turned_by` selector to Cheese Store users.