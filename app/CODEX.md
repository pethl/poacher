# POACHER Review Continuation Note

## Purpose

This note records the agreed process for reviewing and documenting the POACHER Rails application so that work can resume consistently after a break.

## Current Position

The initial project documentation has been started.

Current files:

```text
README.md
docs/
├── architecture.md
├── domain-model.md
├── improvements.md
└── review-notes.md
```

The `Makesheet` model and database schema have been reviewed.

The next area to review is:

```text
IngredientBatchChange
```

Followed by:

```text
DeliveryInspection
MilkQualityMonitor
Sample
```

## Review Principles

Review the code as it currently exists before refactoring it.

Do not clean up or rewrite a model before understanding:

- the business process it supports
- its relationships
- its validations
- its calculations
- its hidden business rules
- the reason for unusual implementation choices

The review should follow the business lifecycle rather than alphabetical file order.

## Outputs for Each Review

For every significant model, controller, service, or workflow, consider four outputs.

### Domain Model

Update:

```text
docs/domain-model.md
```

Add confirmed business concepts, terminology, relationships, calculations, and workflows.

This document explains what the business does. It should not become a field-by-field database reference.

### Architecture

Update:

```text
docs/architecture.md
```

Add confirmed information about how the application is structured, including:

- major components
- important relationships
- architectural patterns
- central or anchor models
- configurable behaviour
- integration boundaries
- significant design decisions

### Improvements

Update:

```text
docs/improvements.md
```

Add actionable technical improvements.

Each item should be specific enough to implement later and should include:

- priority
- affected area
- current behaviour
- reason for reviewing it
- expected improvement

Do not add uncertain assumptions as improvement tasks.

### Review Notes

Update:

```text
docs/review-notes.md
```

Use this file for unresolved questions, assumptions, and matters requiring further investigation or business confirmation.

Once a question is answered, it should be:

- removed,
- converted into permanent documentation, or
- converted into an improvement task.

## Current Open Questions

Important questions already identified include:

- Why are `User` and `Staff` separate concepts?
- What is the intended relationship between them?
- Why are there both `Wash` and `CheeseWashRecord` models?
- Does one makesheet always represent one complete production batch?
- Is the rule permitting only one makesheet per date correct?
- What are all permitted makesheet statuses and transitions?
- What is the exact business stage represented by a `TraceabilityRecord`?
- What does the waste category `T and Bs` mean?
- What types of location are represented by `Location`?

These questions should not be answered by guessing.

## Current Makesheet Findings

`Makesheet` is currently treated as the central production record.

Confirmed relationships include:

- many turns
- many traceability records
- many batch weights
- many ingredient batch changes
- many delivery inspections through ingredient batch changes
- many samples
- one grading note
- optional contact
- optional location
- production and inspection staff
- creating and updating users

Confirmed business behaviour includes:

- make date is required
- make date must currently be unique
- make type is required
- the default status is `Created`
- unfinished records are those not marked `Finished`
- production progress is calculated dynamically
- yield is calculated from total cheese weight and milk used
- predicted yield uses recent makes
- salt calculations use yield, milk quantity, make type, and configured bucket weight
- age is calculated from make date
- cleaning status is inferred from a cleaning check on the same date
- final titration and completion time are derived from the latest populated cutting stage
- numeric fields may be validated using configurable validation ranges

## Existing Makesheet Improvement Areas

The current improvements list should include:

- review deletion behaviour for associated records
- confirm whether one makesheet per date is correct
- document all makesheet statuses and transitions
- simplify the nested `progress` method
- standardise presence checks
- consolidate duplicate date-formatting methods
- filter validation ranges by target model
- consider attaching validation errors to specific fields
- remove HTML generation from the model
- review the date-based cleaning relationship
- review test coverage for yield, salt, progress, validation, and cleaning calculations

## Review Order

Continue in the following order:

```text
1. Makesheet — reviewed

2. IngredientBatchChange
3. DeliveryInspection
4. MilkQualityMonitor
5. Sample

6. TraceabilityRecord
7. BatchWeight
8. WasteRecord

9. Turn
10. CheeseWashRecord
11. Wash

12. GradingNote

13. Contact
14. Picksheet
15. PicksheetItem
16. Invoice
17. MarketSale

18. Reference
19. ValidationRange
20. Location

21. Staff
22. User

23. Supporting operational records
    - Chiller
    - CleaningForeignBodyCheck
    - ScaleCheck
    - Breakage
    - PalletisedDistribution
    - ButterMake
    - ButterStock
```

This order may change when relationships discovered in the code make another sequence more useful.

## Standard Review Questions

For each file, answer:

1. What business concept does this represent?
2. Where does it sit in the operational workflow