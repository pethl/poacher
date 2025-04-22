FactoryBot.define do
  factory :chiller do
    date { Date.today }
    chiller_1 { 4.5 }
    chiller_2 { 5.1 }
    action_taken { "Adjusted door seal" }
    staff
    signature { "Signed by John" }
  end
end
