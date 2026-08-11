FactoryBot.define do
  factory :group do
    key { "office" }
    display_name { "Office" }

    # e.g. create(:group, :hs) instead of create(:group, key: "hs", display_name: "H&S")
    Group::KEYS.each do |group_key|
      trait group_key.to_sym do
        key { group_key }
        display_name { group_key.upcase }
      end
    end
  end
end
