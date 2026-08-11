# Whitelist of models that can be assigned to a group via GroupPermission.
#
# Deliberately NOT dynamic (no constantize on stored strings) — GroupPermission#resource_key
# must be one of these keys, so a bad row in the group_permissions table can never grant
# access to an arbitrary class. Add a line here whenever a new model should become
# permission-able; nothing else needs to change for that model to show up as an option in
# the permission matrix / admin screen.
module PermissionRegistry
  RESOURCES = {
    "batch_weight"                => BatchWeight,
    "breakage"                    => Breakage,
    "butter_make"                 => ButterMake,
    "butter_stock"                => ButterStock,
    "calculation"                 => Calculation,
    "cheese_wash_record"          => CheeseWashRecord,
    "chiller"                     => Chiller,
    "cleaning_foreign_body_check" => CleaningForeignBodyCheck,
    "contact"                     => Contact,
    "delivery_inspection"         => DeliveryInspection,
    "grading_note"                => GradingNote,
    "ingredient_batch_change"     => IngredientBatchChange,
    "invoice"                     => Invoice,
    "location"                    => Location,
    "makesheet"                   => Makesheet,
    "market_sale"                 => MarketSale,
    "milk_quality_monitor"        => MilkQualityMonitor,
    "palletised_distribution"     => PalletisedDistribution,
    "picksheet"                   => Picksheet,
    "picksheet_item"              => PicksheetItem,
    "reference"                   => Reference,
    "sample"                      => Sample,
    "scale_check"                 => ScaleCheck,
    "traceability_record"         => TraceabilityRecord,
    "turn"                        => Turn,
    "validation_range"            => ValidationRange,
    "wash"                        => Wash,
    "wash_picksheet"              => WashPicksheet,
    "waste_record"                => WasteRecord,
  }.freeze

  # Standard actions. "read" and "print_labels" can both apply to the same resource
  # (e.g. Store on Makesheet) — that's two separate GroupPermission rows, not one.
  # assign_location: narrow write for LocationAssignmentsController#create — moving a
  # makesheet to a shelf/aisle/trolley, without granting full :manage on Makesheet.
  ACTIONS = %i[manage read print_labels link assign_location].freeze
end
