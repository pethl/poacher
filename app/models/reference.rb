class Reference < ApplicationRecord
     validates :model, presence: true
     validates :group, presence: true
     validates :value, presence: true
    
     scope :ordered, -> { order(id: :asc) }
end
