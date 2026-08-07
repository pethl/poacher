class CleaningForeignBodyCheck < ApplicationRecord
  include UserTrackable
  belongs_to :user, optional: true

  belongs_to :user_2,
            class_name: "User",
            foreign_key: "user_2_id",
            optional: true

  belongs_to :user_3,
            class_name: "User",
            foreign_key: "user_3_id",
            optional: true
  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :updated_by, class_name: 'User', optional: true

  validates :date, presence: true
  validates :date, presence: true, uniqueness: true

  
end
