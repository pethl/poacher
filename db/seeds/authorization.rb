# db/seeds/authorization.rb
#
# Groups + the bounded-group permission matrix (from poacher_permission_matrix_0.1.xlsx).
# Idempotent (find_or_create_by!) — safe to re-run any time the roster or matrix changes.
# Deliberately NOT loaded from the main db/seeds.rb, which currently destroy_alls core
# business tables and references a removed Staff model. Run this on its own instead:
#
#   bin/rails permissions:seed
#
# Admin and Mgmt are blanket access (see app/models/ability.rb) and never need rows here.

groups = {
  "admin"   => "Admin",
  "mgmt"    => "Mgmt",
  "office"  => "Office",
  "hs"      => "H&S",
  "dairy"   => "Dairy",
  "store"   => "Store",
  "cutting" => "Cutting",
}

groups_by_key = groups.each_with_object({}) do |(key, display_name), memo|
  memo[key] = Group.find_or_create_by!(key: key) { |g| g.display_name = display_name }
end

# resource_key => { group_key => [actions] }
permissions = {
  # Cutting gets read-only — it's a report of their own work, Mgmt wants them to see it.
  # Nobody else has any access (Admin/Mgmt only otherwise, via blanket).
  "batch_weight"                => { "cutting" => %i[read] },
  "breakage"                    => { "hs" => %i[read print_labels], "cutting" => %i[manage] },
  "butter_make"                 => { "office" => %i[manage] },
  "butter_stock"                => { "office" => %i[manage] },
  "calculation"                 => { "office" => %i[manage] },
  "cheese_wash_record"          => { "store" => %i[manage], "cutting" => %i[read] },
  "chiller"                     => { "hs" => %i[read], "cutting" => %i[manage] },
  "cleaning_foreign_body_check" => { "hs" => %i[read], "dairy" => %i[manage] },
  "contact"                     => { "office" => %i[manage] },
  "delivery_inspection"         => { "office" => %i[read], "dairy" => %i[manage] },
  "grading_note"                => { "office" => %i[manage], "hs" => %i[read], "cutting" => %i[read] },
  "ingredient_batch_change"     => { "office" => %i[read], "hs" => %i[read], "dairy" => %i[manage] },
  "invoice"                     => { "office" => %i[manage] },
  "location"                    => { "office" => %i[manage], "hs" => %i[read], "store" => %i[read] },
  # cutting's "read" added beyond the original spreadsheet: MakesheetsController#summary
  # is used by the traceability_records form JS, and Cutting manages traceability_record —
  # it needs to read the makesheet it's recording against.
  # store's "assign_location" is a narrow custom action for LocationAssignmentsController's
  # create (moving a makesheet to a shelf/aisle/trolley) — not full :manage on Makesheet.
  "makesheet"                   => { "office" => %i[read], "hs" => %i[read print_labels],
                                       "dairy" => %i[manage], "store" => %i[read print_labels assign_location],
                                       "cutting" => %i[read link] },
  "market_sale"                 => { "office" => %i[manage] },
  "milk_quality_monitor"        => { "office" => %i[read], "hs" => %i[manage] },
  "palletised_distribution"     => { "office" => %i[manage] },
  "picksheet"                   => { "office" => %i[manage], "cutting" => %i[read] },
  "picksheet_item"              => { "office" => %i[manage], "cutting" => %i[manage] },
  "reference"                   => { "office" => %i[manage] },
  "sample"                      => { "office" => %i[read], "hs" => %i[manage], "dairy" => %i[read] },
  "scale_check"                 => { "office" => %i[read], "hs" => %i[read], "cutting" => %i[manage] },
  "traceability_record"         => { "office" => %i[read], "cutting" => %i[manage] },
  "turn"                        => { "office" => %i[read], "store" => %i[manage] },
  "validation_range"            => { "office" => %i[manage], "dairy" => %i[manage] },
  "wash"                        => { "office" => %i[read], "store" => %i[manage], "cutting" => %i[read] },
  # WashPicksheetsController has no actions — these rows aren't enforced by anything.
  # WashPicksheet rows are only ever written via Wash#create/#update (picksheet_ids: []),
  # gated by Wash's own :manage (Store). Kept here for documentation/consistency, matching
  # who can actually touch it, not the original spreadsheet's "cutting manages" guess.
  "wash_picksheet"              => { "office" => %i[read], "store" => %i[manage] },
  "waste_record"                => { "office" => %i[read], "cutting" => %i[manage] },
}

created = 0

permissions.each do |resource_key, group_actions|
  unless PermissionRegistry::RESOURCES.key?(resource_key)
    raise "db/seeds/authorization.rb: unknown resource_key #{resource_key.inspect} — not in PermissionRegistry::RESOURCES"
  end

  group_actions.each do |group_key, actions|
    group = groups_by_key.fetch(group_key) do
      raise "db/seeds/authorization.rb: unknown group_key #{group_key.inspect}"
    end

    actions.each do |action|
      record = GroupPermission.find_or_create_by!(group: group, resource_key: resource_key, action: action.to_s)
      created += 1 if record.previously_new_record?
    end
  end
end

puts "Groups: #{groups_by_key.size} ensured. GroupPermission rows: #{created} created (rest already existed)."
