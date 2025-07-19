class CleaningForeignBodyCheck < ApplicationRecord
  include UserTrackable
  belongs_to :staff, class_name: "Staff", optional: true
  belongs_to :staff_2, class_name: "Staff", foreign_key: "staff_id_2", optional: true
  belongs_to :staff_3, class_name: "Staff", foreign_key: "staff_id_3", optional: true
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true


  validates :date, presence: true
end
