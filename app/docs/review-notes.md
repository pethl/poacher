

Question

Why are Staff and User separate?


Need to inspect authentication and business workflow.
## Delivery Inspection / Ingredient Batch Change

- [x] Replace `dependent: :restrict_with_error` on DeliveryInspection.
- - [x] Can one delivered batch be used across several makesheets?
  - Yes. A batch may span several makesheets.
  - Users record only batch-change points, and usage between those dates is inferred.
- [ ] Plan the retirement of `makesheets.ingredient_batch_change`.
  - Historical makesheets continue to use the legacy text field.
  - New makesheets use structured `IngredientBatchChange` records.
  - Define the cut-over date and remove the legacy field once it is no longer required.
- [ ] Add tests and reporting safeguards for inferred ingredient batch usage, including the first known batch, date ordering, and corrections to historical change points.


## Milk Quality Monitoring

- Where is the held or flagged status stored?
- Is a hold applied to one makesheet, several makesheets, or all production within a date range?
- Which result limits trigger a hold?
- Who clears a hold, and what evidence is required?
- Can one makesheet have more than one milk-quality result?


## Laboratory Samples

- Where will sample holds and releases be recorded?


## Batch Traceability

- Is `total_weight_of_batch` manually confirmed by staff or expected to equal the calculated sum of individual weights?
- Should traceability records and their waste records ever be physically deleted?
- What does the waste category `T and Bs` mean?