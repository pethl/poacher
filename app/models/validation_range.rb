class ValidationRange < ApplicationRecord
  # Associations for user tracking
  belongs_to :creator, class_name: 'User', foreign_key: :created_by, optional: true
  belongs_to :updater, class_name: 'User', foreign_key: :updated_by, optional: true

  # Validations
  validates :field_name, presence: true, uniqueness: true
  validates :min_value, numericality: true, allow_nil: true
  validates :max_value, numericality: true, allow_nil: true
  validate :min_less_than_or_equal_to_max
  validate :field_name_exists_on_model

  def field_name_exists_on_model
    return unless target_model.present? && field_name.present?

    klass = target_model.safe_constantize
    unless klass&.column_names&.include?(field_name)
      errors.add(:field_name, "is not a valid field for #{target_model}")
    end
  end

  def min_less_than_or_equal_to_max
    if min_value.present? && max_value.present? && min_value > max_value
      errors.add(:min_value, "can't be greater than max value")
    end
  end
  scope :ordered_by_field_name, -> { order(:field_name) }
end
