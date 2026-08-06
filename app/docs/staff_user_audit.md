# Staff / User Audit

Model	Current Staff usage	Likely decision
Makesheet 🔴	cheese_made_by_staff, assistant_staff, pre_start_inspection_by_staff	Biggest one. Decide User vs retained Staff
DeliveryInspection	staff_id, signature	Likely → User
CleaningForeignBodyCheck	staff_id, staff_id_2, staff_id_3	Likely → User(s)
ScaleCheck	staff_id	Likely → User
Chiller	staff_id	Likely → User
Breakage	staff_id	Likely → User
PalletisedDistribution	staff_id, signature	Likely → User
GradingNote ✅	Head taster + guest tasters	Done

## Purpose

Review all remaining uses of Staff and decide whether each reference should become:

- User (person with login/accountability)
- Name/text field (guest, visitor, historical participant)
- Remain Staff (true operational employee record)

Guiding rule:

> If they log in → User.
> If they participate but don't need an account → name/text.
> If the business needs employee records separate from login → Staff may remain.

---

# Completed

## Grading Notes ✅

Status:
DONE

Decision:
- Head Taster → User
- Other tasters → free text names

Reason:
Guest tasters do not require system accounts.

---

# Priority Audit Areas

## 1. Makesheets 🔴 HIGH PRIORITY

Files:
app/models/makesheet.rb
app/controllers/makesheets_controller.rb
app/views/makesheets/
spec/models/makesheet_spec.rb
spec/factories/makesheet.rb
db/migrate/20240804162025_create_makesheets.rb

Current fields:

pre_start_inspection_by_staff_id
pre_start_inspection_by_2_staff_id
cheese_made_by_staff_id
assistant_staff_id

Questions:

- Are these people always employees?
- Do they need login accounts?
- Should they become User references?
- Should assistant remain a name?

Likely outcome:

cheese_made_by_staff_id
→ User
inspection_by_staff_id
→ User
assistant_staff_id
→ maybe User or text

---

## 2. Food Safety Checks 🔴 HIGH PRIORITY

### Delivery Inspections

Files:

app/models/delivery_inspection.rb
app/controllers/delivery_inspections_controller.rb
app/views/delivery_inspections/
spec/models/delivery_inspection_spec.rb

Current:

staff_id
staff_signature

Decision needed:

Does the checker need a login?

Possible:

staff_id → user_id

Signature probably remains.

---

### Cleaning Foreign Body Checks

Files:

app/models/cleaning_foreign_body_check.rb
app/controllers/cleaning_foreign_body_checks_controller.rb
app/views/cleaning_foreign_body_checks/

Current:

staff_id
staff_id_2
staff_id_3

Question:

Are these multiple operators signing off?

Possible:

user_id
user_id_2
user_id_3

or names.

---

### Scale Checks

Files:

app/models/scale_check.rb
app/controllers/scale_checks_controller.rb

Current:

staff_id

Likely:

user_id

---

### Chillers

Files:

app/models/chiller.rb
app/controllers/chillers_controller.rb

Current:

staff_id

Likely:

user_id

---

## 3. Distribution Records 🟡

Files:

app/models/palletised_distribution.rb
app/controllers/palletised_distributions_controller.rb

Current:

staff_id
staff_signature

Decision:

Probably User.

---

## 4. Breakages 🟡

Files:

app/models/breakage.rb
app/controllers/breakages_controller.rb

Current:

staff_id

Decision:

Probably User.

---

# Staff Model Itself 🟢

Files:

app/models/staff.rb
app/controllers/staffs_controller.rb
app/views/staffs/
db/migrate/20241029072455_create_staffs.rb

Do not remove yet.

Need to decide:

Option A:
Retire Staff completely.

Option B:
Keep Staff as employee directory and link:

User belongs_to Staff

This is a bigger architecture decision.

---

# Seeds

Review:

db/seeds/staff.rb
db/seeds/makesheets.rb
db/seeds/references.rb
db/seeds.rb

Need to decide whether seed Staff remains.

---

# Factories / Specs

Update after each model conversion:

spec/factories/staffs.rb
spec/factories/makesheet.rb
spec/factories/chiller.rb
spec/factories/scale_checks.rb
spec/factories/delivery_inspections.rb
spec/factories/palletised_distributions.rb
spec/factories/cleaning_foreign_body_checks.rb

---

# Documentation

Review after technical changes:

app/CODEX.md
app/docs/domain-model.md
app/docs/review_order.md
app/docs/improvements.md
app/docs/review-notes.md

---

# Final Cleanup (LAST)

Only after all migrations complete:

- Remove unused Staff references
- Remove Staff controller/views
- Remove Staff factory
- Remove Staff seeds
- Remove Staff table
- Update documentation