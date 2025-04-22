# spec/factories/milk_quality_monitors.rb
FactoryBot.define do
  factory :milk_quality_monitor do
    sample_date { Date.today }
    makesheet
  end
end
