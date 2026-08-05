# Domain Model

## Purpose

This document describes the principal business concepts used by POACHER and how they relate to one another.

It is intended to explain the language and structure of the business domain rather than document every database table or Rails model in detail.

The document will be refined as the application code and business workflows are reviewed.

---

## Domain Overview

POACHER supports the operational lifecycle of cheese production:

```text
Ingredients and Milk
        │
        ▼
Cheese Make
        │
        ├── Production measurements and observations
        ├── Ingredient traceability
        ├── Milk quality results
        └── Required samples
        │
        ▼
Storage and Ageing
        │
        ├── Location
        ├── Turning
        ├── Grading
        └── Washing
        │
        ▼
Cutting and Traceability
        │
        ├── Batch weights
        ├── Individual cheese weights
        └── Waste
        │
        ▼
Orders and Distribution
        │
        ├── Picksheets
        ├── Products and quantities
        ├── Customers
        └── Distribution records
        │
        ▼
Sales and Reporting
```

Alongside this primary flow, POACHER records food safety checks, laboratory samples, staff activity, equipment checks, cleaning, breakages, butter production and management information.

---

## Core Production Domain

## Makesheet

A **Makesheet** is the central cheese-production record in POACHER.

It represents the production activity carried out on a particular make date and captures the main measurements, ingredients, timings, observations, staff involvement, quality controls and production outcomes for that make.

A makesheet records information including:

- make date and make type
- batch identifier
- workflow status
- milk quantity
- expected and actual yield
- total cheese weight
- number of cheeses produced
- starter culture, rennet and salt usage
- production timings
- temperatures and titration readings
- moisture measurements
- production staff
- pre-start inspection staff
- production observations
- contamination and breakage indicators
- samples required
- post-make notes
- assigned contact and location

The make date and make type are mandatory.

The application currently permits only one makesheet for each make date.

### Makesheet Relationships

A makesheet may have:

- many turns
- many traceability records
- many batch-weight records
- many ingredient batch changes
- many delivery inspections through ingredient batch changes
- many laboratory samples
- one grading note

A makesheet may also belong to:

- a contact
- a location
- the staff member who made the cheese
- one or two staff members responsible for the pre-start inspection
- the users who created and last updated the record

Some related records are currently retained if a makesheet is deleted, while ingredient batch changes and grading notes are deleted with it. The intended retention policy should be reviewed before deletion behaviour is changed.

### Production Status

A makesheet has a workflow status.

The database default is:

```text
Created
```

The model also defines unfinished makesheets as those whose status is not:

```text
Finished
```

The full set of permitted status values and the actions that move a makesheet between statuses should be confirmed from the controllers, forms and user interface.

### Production Progress

The application calculates an additional progress indicator independently of the makesheet status.

The progress values are:

| Value | Meaning |
|---|---|
| `N` | Core production information has not yet been entered |
| `I` | Initial make and ingredient information has been entered |
| `II` | Required cutting-stage information has been entered |
| `III` | Final production weight and cheese count have been entered |
| `IV` | Production information is complete, including the pre-start inspector |

This progress value is calculated dynamically and is not stored in the database.

The exact fields used to determine each stage are implementation details and may change as the production workflow is refined.

### Yield

Actual production yield is calculated as:

```text
total cheese weight ÷ milk used × 100
```

If no milk quantity has been recorded, the yield is treated as zero.

The application can also calculate an average yield from the ten most recent makes before today. This recent average is used as the predicted yield for a makesheet when required.

### Salt Calculation

The expected net salt quantity is calculated using:

- milk quantity
- expected yield, or predicted yield if no expected yield is present
- a salt factor based on the make type

The current calculation uses a slightly different factor for the `Red` make type.

Gross salt adds a configured bucket weight to the calculated net salt quantity. The bucket weight is obtained from active reference data in the `bucket_weight` reference group.

### Age

The application derives the age of a makesheet from its make date.

Age can be displayed in:

- days
- weeks
- approximate months

These values are calculated dynamically using the current date.

### Cleaning Status

The cleaning status for a makesheet is inferred from the cleaning and foreign-body check recorded on the same date as the make.

Possible results are:

| Status | Meaning |
|---|---|
| `Not Started` | No matching cleaning check exists, or no check items are complete |
| `Incomplete` | Some cleaning items are complete |
| `Complete` | All required cleaning items are complete |

This is currently a date-based relationship rather than an explicit database association.

### Final Titration and Production Time

The final titration is taken from the latest populated cutting-stage titration, working backwards from the seventh cut to the first cut.

The production completion time is similarly derived from the latest populated cutting-stage time.

These are calculated values rather than stored fields.

### Production Flags

A makesheet may display operational flags for:

- slow cheese
- metal contamination
- glass breakage
- associated laboratory samples

The sample flag links to the first associated sample.

### Configurable Validation Ranges

Numeric makesheet fields may be checked against active validation ranges stored in the database.

A validation range identifies:

- the field being checked

---

## Incoming Goods and Ingredient Traceability

### Delivery Inspection

A **Delivery Inspection** records the acceptance and inspection of an incoming ingredient or other delivered item.

Each inspection identifies:

- delivery date
- item received
- supplier or manufacturer batch number
- best-before date
- whether the required certificate was received
- whether damage was found
- whether foreign-body contamination was found
- whether pest contamination was found
- whether the delivery was timely
- whether the delivery was satisfactory
- whether the item should be placed on hold
- comments
- the staff member completing the inspection
- the staff member’s signature

The delivery date, item, batch number, best-before date, responsible staff member, and signature are mandatory.

The inspection also requires explicit yes-or-no responses for:

- certificate received
- damage
- foreign contamination
- pest contamination
- satisfactory condition

A delivery inspection may be linked to several cheese makes through ingredient batch-change records.

### Recent Delivery History

The application can retrieve the three most recent delivery inspections for a given item.

This provides a short history of recently received batches and may assist users when selecting the ingredient batch used during production.

### Best-Before Validation

The application currently requires the best-before date to be today or later when the inspection is validated.

This rule should be reviewed because it may affect the editing or importing of historical delivery records.

## Delivery Inspection

Records an incoming item or ingredient batch, including delivery date, batch number, best-before date, inspection results, staff member and signature.

## Ingredient Batch Change

Links a Makesheet to a Delivery Inspection when the ingredient batch changes during production. It records the item, change date and optional notes.

### Inferred Ingredient Batch Usage

A delivered ingredient batch may be used across several makesheets.

Users record only the point at which the ingredient batch changes. The batch used by makesheets between recorded change points is inferred from the most recent applicable ingredient batch change.

This reduces repetitive data entry, but means traceability depends on the accuracy and ordering of the recorded change points.

### Legacy Ingredient Batch Data

Earlier versions of POACHER stored ingredient batch changes as free text on the Makesheet.

New makesheets use structured `IngredientBatchChange` records linked to `DeliveryInspection` records.

The legacy text field is retained to preserve historical data created before the introduction of structured ingredient traceability.

Once the system has fully transitioned and historical requirements have been reviewed, the legacy field may be removed.

## Milk Quality Monitor

A **Milk Quality Monitor** records laboratory results for milk sampled from the vat before cheese production begins.

Results are imported from laboratory data and linked to the makesheet for the relevant production date. Measurements include cell count, Bactoscan, butterfat, lactose, protein, casein, urea, colony counts, thermoduric bacteria and coliforms.

Results outside acceptable limits may cause cheese to be held or flagged until later test results confirm that it can be released.

---

## Laboratory Sample

A **Sample** records laboratory test results imported from CSV or Excel files.

Samples may contain microbiological, compositional or nutritional results and can be linked to one or more makesheets. Unsatisfactory results may lead to affected cheese being held until later testing confirms release.

### Sample Import Behaviour

Laboratory downloads may contain results that were imported previously.

Samples are identified by `sample_no`. Existing samples are not updated during later imports because the laboratory does not revise historical results. Only previously unseen sample numbers are added.

### Linking Samples to Production

Laboratory samples are linked to makesheets manually by the Health and Safety Manager after the laboratory results have been imported.

This allows laboratory testing to be completed independently of cheese production and accommodates results that may be received some time after the cheese has been made.

### Composite Samples

A laboratory sample may represent cheese from more than one make.

Composite samples are linked to each relevant makesheet so the laboratory result can be traced back to all included production dates.

--

## Storage and Ageing

### Location

A **Location** represents a physical or operational place used by the application.

A location has:

- a name
- a location type
- a display order
- an active status

Makesheets may be assigned to a location. The precise location types and the point at which location changes occur should be confirmed from the application workflows.

### Turn

A **Turn** records that cheeses from a makesheet were turned during storage or ageing.

It contains:

- the makesheet
- the date and time of the turn
- who performed the turn

### Cheese Wash Record

A **Cheese Wash Record** records the washing process for cheeses belonging to a makesheet.

It contains:

- the date the batch entered the washing process
- the date the batch completed the process
- up to 24 recorded wash dates
- the number of cheeses washed on each date

The record appears to represent the complete washing history for one production batch.

### Wash

A **Wash** appears to represent an operational washing activity or washing work allocation.

It records:

- action date
- wash status

Washes can be connected to picksheets through wash-picksheet records. The distinction between a `Wash` and a `CheeseWashRecord` should be confirmed from the code and business workflow.

### Grading Note

A **Grading Note** records the quality assessment of cheese from a makesheet.

It includes:

- grading date
- appearance
- bore
- texture
- taste
- score
- comments
- head and assistant tasters

---

## Cutting, Weights and Traceability

## Batch Traceability

A **Traceability Record** follows one makesheet batch through washing and maturation.

A batch normally contains approximately 16–23 cheeses, each weighing around 20 kg. Each cheese is weighed individually, allowing POACHER to re-confirm:

- the number of cheeses in the batch - when they go for washing 
- the total batch weight at washing
- waste attributed to the batch

The later batch count can be compared with the original production count on the makesheet to check for loss/theft during storage.

The later batch weight can be compared with the original production weight on the makesheet to measure weight loss through maturation and shrinkage.

Each makesheet may have only one traceability record.

Waste is recorded separately against the traceability record using defined waste categories.


### Batch Weight Tracking

A TraceabilityRecord represents the washing and maturation stage of a single cheese batch.

Individual cheese weights are recorded as each cheese enters the washing process. Washing may take place over several days, so only the cheeses processed to date are recorded.

The application stores:

- `confirmed_number_of_cheeses` — the current number of cheeses that have been individually weighed.
- `total_weight_of_batch` — the cumulative weight of all cheeses weighed so far.

These values are derived from the recorded individual cheese weights and represent the current progress of the batch through washing.

The original production values remain on the linked Makesheet and are used as the reference values for comparison.


## Waste Record

A WasteRecord stores the waste attributed to one traceability batch for one working day.

Staff enter one combined waste record at the end of each day. Waste is divided into the agreed operational categories and contributes to the batch’s total waste.
---

## Batch Weight

A BatchWeight records the final washed batch weight and waste for a makesheet.

Creating the record marks the linked makesheet as finished. This is the final operational step in the makesheet lifecycle.

Batch weights may need correction, but editing should be restricted to authorised management users.

## Samples and Laboratory Testing

### Sample

A **Sample** stores laboratory sample information and test results.

It includes:

- sample number
- received date
- sample description
- test suite
- classification
- schedule
- indicator
- barcode count

The record supports a wide range of microbiological, nutritional and compositional results, including:

- aerobic plate counts
- coliforms
- *E. coli*
- *Listeria*
- *Salmonella*
- *Staphylococcus*
- moisture
- pH
- salt
- fat
- protein
- sugars
- energy values
- water activity

Makesheets and samples have a many-to-many relationship, allowing a sample to be associated with one or more makesheets.

---

## Customers, Orders and Sales

### Contact

A **Contact** represents a customer, supplier, or other business contact.

It records:

- business and contact names
- internal reference
- email and telephone details
- address and country
- payment arrangements
- terms and conditions
- delivery-note preferences
- notes

The different roles a contact may play should be confirmed from the application.

### Picksheet

A **Picksheet** represents a customer order or fulfilment instruction.

It records:

- customer
- date the order was placed
- required delivery date and time
- order number
- invoice number
- carrier details
- number of boxes
- assigned user
- status

### Picksheet Item

A **Picksheet Item** represents an individual product line on a picksheet.

It may contain:

- associated makesheet
- product
- size
- count
- weight
- product code
- selling price
- best-before date
- pricing method
- custom notes

Linking a picksheet item to a makesheet supports traceability from an ordered product back to its production batch.

### Invoice

An **Invoice** stores summary invoice information, including:

- invoice number
- account
- date
- amount
- weight

The relationship between invoices, contacts and picksheets should be confirmed because the current database does not enforce direct foreign-key relationships between them.

### Market Sale

A **Market Sale** records sales made at a market or similar retail event.

It includes sales values for:

- cheese
- butter
- honey
- eggs
- plum bread
- milk
- other cheese

It also records the market, seller, date, total sales and product weight.

### Palletised Distribution

A **Palletised Distribution** records checks and details for a palletised dispatch.

It includes:

- distribution date
- transport company
- registration and trailer details
- vehicle temperature
- vehicle cleanliness
- destination
- number of pallets
- staff and driver signatures

---

## Food Safety and Operational Checks

POACHER records several operational and food-safety controls.

### Cleaning and Foreign Body Check

Records cleaning and foreign-body checks for production areas and equipment, including:

- milk pipeline
- cheese vat
- mill
- moulds and tables
- hand equipment
- presses
- sinks
- floors
- drains
- footbaths
- compressors
- protective equipment

The record may be signed or completed by several staff members.

### Breakage

A **Breakage** records damaged tools or equipment that may present a contamination risk.

It can record breakage involving:

- knives
- cutting boards or wires
- ringing-machine wires
- cutting springs
- other equipment

It also records whether product was contaminated and what action was taken.

### Chiller Check

A **Chiller Check** records chiller temperatures, corrective action, staff member and signature.

### Scale Check

A **Scale Check** records calibration or accuracy checks for named scales using defined test weights.

### Validation Range

A **Validation Range** stores configurable minimum and maximum values for a field on a target model.

This appears to support validation of operational measurements without hard-coding every allowable range.

The models and fields currently controlled through these records should be documented after reviewing the validation implementation.

---

## Staff and Application Users

### Staff

A **Staff** record represents an employee involved in operational activities.

It contains:

- first name
- last name
- employment status
- department
- role

Staff records are referenced by food safety, inspection, distribution and production records.

### User

A **User** is an authenticated application account.

Users log in using Devise and may have:

- an administrator flag
- a role
- an active or inactive account state

A user account and a staff record are currently separate concepts.

This suggests that:

- a staff member may be named on an operational record without necessarily having an application login
- a user represents access to POACHER
- a staff record represents a person participating in business operations

The intended relationship between users and staff should be confirmed.

### Audit Fields

Many records contain:

- `created_by_id`
- `updated_by_id`

These fields link changes to application users and provide an audit trail of who created or last updated a record.

---

## Supporting and Reference Data

### Reference

A **Reference** record provides configurable lookup values.

It includes:

- group
- value
- description
- related model
- sort order
- active status

Reference data may be used for selectable values that need to be maintained without changing application code.

### Calculation

A **Calculation** stores product, size, weight and notes.

Its precise role should be confirmed from the relevant model and user interface.

---

## Butter Operations

Butter production is represented separately from the principal cheese-production workflow.

### Butter Make

A **Butter Make** records:

- date
- cream
- quantity made
- stock

### Butter Stock

A **Butter Stock** records butter production, returns and stock across several butter types and storage categories.

The units used by these fields should be documented once confirmed.

---

## Important Relationships

The principal relationships visible from the database are:

```text
Makesheet
 ├── Batch Weights
 ├── Cheese Wash Record
 ├── Grading Notes
 ├── Ingredient Batch Changes
 │    └── Delivery Inspection
 ├── Milk Quality Monitors
 ├── Picksheet Items
 ├── Samples
 ├── Traceability Records
 │    └── Waste Records
 └── Turns

Contact
 ├── Makesheets
 └── Picksheets
      └── Picksheet Items
           └── Makesheet

Wash
 └── Wash Picksheets
      └── Picksheet

Staff
 ├── Breakages
 ├── Chiller Checks
 ├── Cleaning Checks
 ├── Delivery Inspections
 ├── Palletised Distributions
 └── Scale Checks

User
 └── Creates and updates many operational records
```

---

## Terms Requiring Confirmation

The following terms should be reviewed with someone familiar with the business or confirmed from the application code:

| Term | Question |
|---|---|
| Makesheet | Does one makesheet always represent one complete cheese-production batch? |
| Make type | What values are allowed, and how do they affect the workflow? |
| Batch | Is the batch identifier unique, and when is it assigned? |
| Contact | Can one contact act as both supplier and customer? |
| Traceability record | Which physical process begins and ends this record? |
| Wash | How does it differ from a cheese wash record? |
| T and Bs | What waste category does this abbreviation represent? |
| Calculation | Which operational calculation or workflow uses this record? |
| Staff and User | Are application users formally linked to staff members elsewhere? |
| Location | Does this represent production rooms, stores, shelves, or all of these? |

---

## Scope

This document intentionally focuses on the major business concepts.

It does not attempt to list every field, validation, report, controller or user-interface action. More detailed workflow documentation will be added separately as each area of the application is reviewed.