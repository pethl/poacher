class CleaningForeignBodyCheck < ApplicationRecord
  belongs_to :staff, class_name: "Staff", optional: true
  belongs_to :staff_2, class_name: "Staff", foreign_key: "staff_id_2", optional: true
  belongs_to :staff_3, class_name: "Staff", foreign_key: "staff_id_3", optional: true


  validates :date, presence: true
end
