class Wash < ApplicationRecord
  has_many :wash_picksheets
  has_many :picksheets, through: :wash_picksheets
end
