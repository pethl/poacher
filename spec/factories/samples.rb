# spec/factories/samples.rb
FactoryBot.define do
  factory :sample do
    sequence(:sample_no) { |n| "SAMPLE#{n}" } # includes letters now
    received_date { Date.today }
    indicator { "Test" }
    sample_description { "Test description" }
    makesheet
  end
end
