# Authorization Rollout — Model Checklist

Tracks which controllers actually **enforce** (`authorize!`) the permissions defined in
`db/seeds/authorization.rb`. Being in that file only means the *rule exists* — a model isn't
locked down until its controller checks it too. See `app/docs/architecture.md` for how the
system fits together, and `poacher_permission_matrix_0.1.xlsx` for the business-level source
of truth.

Pattern used throughout: read-only actions (`index`, `show`, dashboards/reports) require
`:read`; actions that create/change/destroy a record require `:manage`; a couple of models
have narrower custom actions (`:print_labels`, `:link`) — see the model's row below.

## Not model-specific

- [x] Section-level nav gating (`PagesController` `_home` actions + `_main_nav.html.erb`) —
      coarse "can this user see the Dairy/Store/Cutting/Office/Mgmt area at all" check.
- [x] `UsersController` — `:manage` on `User`, Admin only (assigning groups/dept).

## Models (`PermissionRegistry::RESOURCES`)

- [x] **Makesheet** — `MakesheetsController` + `LabelsController` (print/hold/release labels).
      Dairy: manage · Office: read · H&S: read + print_labels · Store: read + print_labels ·
      Cutting: read + link.
- [x] **Sample** — `SamplesController`. Office: read · H&S: manage · Dairy: read.
- [x] **BatchWeight** — `BatchWeightsController`. Cutting: read (it's a report on their own
      work, Mgmt wants them to see it). Nobody else outside Admin/Mgmt.
- [x] **Breakage** — `BreakagesController`. H&S: read + print_labels · Cutting: manage.
- [ ] **ButterMake** — `ButterMakesController`. Office: manage. HOLD — butter feature is
      still unstable and may get reworked/undone, don't lock down yet.
- [ ] **ButterStock** — `ButterStocksController`. Office: manage. HOLD — same as ButterMake,
      feature may still change significantly.
- [x] **Calculation** — `CalculationsController`. Office: manage.
- [x] **CheeseWashRecord** — `CheeseWashRecordsController`. Store: manage · Cutting: read.
- [x] **Chiller** — `ChillersController`. H&S: read · Cutting: manage.
- [x] **CleaningForeignBodyCheck** — `CleaningForeignBodyChecksController`. H&S: read · Dairy: manage.
- [x] **Contact** — `ContactsController`. Office: manage.
- [x] **DeliveryInspection** — `DeliveryInspectionsController`. Office: read · Dairy: manage.
- [x] **GradingNote** — `GradingNotesController`. Office: manage · H&S: read · Cutting: read.
      `preload`/`preload_form`/`create_preloaded` (bulk-create workflow) sit on `:manage`
      alongside the usual CRUD actions.
- [x] **IngredientBatchChange** — `IngredientBatchChangesController`. Office: read · H&S: read · Dairy: manage.
      Nested under makesheet_id, only `new`/`create` exist.
- [x] **Invoice** — `InvoicesController`. Office: manage.
- [x] **Location** — `LocationsController`. Office: manage · H&S: read · Store: read. Also
      introduces `clear_location_assignment`, gated by the same `:assign_location` custom
      action on Makesheet (Store) used by `location_assignments_controller.rb`, since it
      writes to the same `makesheet.location_id` field. `print_wizard` was routed and linked
      from `office_home` + `locations/index` but had no controller action at all — fixed by
      adding an empty `def print_wizard; end` (same pattern as `show`/`edit`); it's covered
      by the same `:read` gate as the rest of the read actions.
- [x] **MarketSale** — `MarketSalesController`. Office: manage.
- [x] **MilkQualityMonitor** — `MilkQualityMonitorsController`. Office: read · H&S: manage.
- [x] **PalletisedDistribution** — `PalletisedDistributionsController`. Office: manage.
- [x] **Picksheet** — `PicksheetsController`. Office: manage · Cutting: read. All the
      dashboard/report/PDF actions (`hold_picksheets`, `daily_cheese_manifest`,
      `print_picksheet_pdf`, etc.) sit on `:read`; `move_to_cutting_room` (bulk status
      update) is `:manage`.
- [x] **PicksheetItem** — `PicksheetItemsController`. Office: manage · Cutting: manage.
      Nested under picksheet_id. Only `show` sits on `:read` — both groups already have
      `:manage`, so it's mostly documentation here, not an actual gate.
- [x] **Reference** — `ReferencesController`. Office: manage.
- [x] **ScaleCheck** — `ScaleChecksController`. Office: read · H&S: read · Cutting: manage.
- [x] **TraceabilityRecord** — `TraceabilityRecordsController`. Office: read · Cutting: manage.
- [x] **Turn** — `TurnsController`. Office: read · Store: manage.
- [x] **ValidationRange** — `ValidationRangesController`. Office: manage · Dairy: manage.
- [x] **Wash** — `WashesController`. Office: read · Store: manage · Cutting: read.
- [x] **WashPicksheet** — `WashPicksheetsController` is an empty shell (no actions). The join
      is only ever written via `Wash#create`/`#update` (`picksheet_ids: []`), already gated by
      Wash's own `:manage` check. Nothing separate needed.
- [x] **WasteRecord** — `WasteRecordsController`. Office: read · Cutting: manage.

## No dedicated model — worked out case by case

- [x] **`location_assignments_controller.rb`** — no `LocationAssignment` model; works across
      `Location` and `Makesheet`. Reports (`location_report`, `inspection_results`) need
      `:read` on Location. The real write, `create` (assign a makesheet to a shelf/aisle/
      trolley), uses a new narrow custom action `:assign_location` on Makesheet — Store only,
      not full `:manage`.
- [x] **`audit_reports_controller.rb`** — no `AuditReport` model; single read-only `show`
      report over Makesheet/IngredientBatchChange/DeliveryInspection. Dairy: owns it ·
      Office: read · Mgmt: read (via blanket). Pegged to `:read`/`:manage` on
      `DeliveryInspection`, which already has exactly that split — no seed changes needed.
- [x] **`vacuum_pouch_calculator_controller.rb`** — no model, nothing persisted, single
      standalone calculator page. Future use undecided (may end up feeding a `PicksheetItem`
      value). Pegged to `:manage` on `PicksheetItem` (Office + Cutting) — revisit if this
      tool goes fully standalone and Office shouldn't see it.

## Workflow for each one

1. Read the controller, map its actions to `:read` / `:manage` (or a custom action).
2. Add `before_action :authorize_x_read!` / `:authorize_x_manage!` + the two private methods
   (see `MakesheetsController` or `SamplesController` for the pattern).
3. `ruby -c` the file.
4. Tick it off here.
5. Test as a couple of different groups before moving to the next one.
