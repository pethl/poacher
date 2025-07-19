# app/models/concerns/user_trackable.rb
module UserTrackable
  extend ActiveSupport::Concern

  included do
    before_create :set_created_by
    before_save :set_updated_by
  end

  private

  def set_created_by
    self.created_by ||= Thread.current[:current_user] if respond_to?(:created_by)
  end

  def set_updated_by
    self.updated_by = Thread.current[:current_user] if respond_to?(:updated_by)
  end
end

