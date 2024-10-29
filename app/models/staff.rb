class Staff < ApplicationRecord
  scope :ordered, -> { order(last_name: :asc) }

  def full_name
    "#{self.first_name} #{self.last_name}"

  end
end
