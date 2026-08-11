FactoryBot.define do
  factory :group_permission do
    group
    resource_key { "sample" }
    action { "read" }
  end
end
