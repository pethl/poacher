class Reference < ApplicationRecord
     include UserTrackable
     belongs_to :created_by, class_name: 'User', optional: true
     belongs_to :updated_by, class_name: 'User', optional: true

     validates :model, presence: true
     validates :group, presence: true
     validates :value, presence: true
    
     scope :ordered, -> { order(sort_order: :asc) }
end
