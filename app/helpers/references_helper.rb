module ReferencesHelper
  def reference_model_options
    Rails.application.eager_load! if Rails.env.development? && !Rails.application.config.eager_load
  
    models = ApplicationRecord.descendants.map(&:name).sort
    [["System Wide", "System Wide"]] + models.map { |model| [model, model] }
  end
end
