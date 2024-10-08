class Reference < ApplicationRecord
     validates :group, presence: true
    validates :value, presence: true
    
     scope :ordered, -> { order(id: :asc) }
end
