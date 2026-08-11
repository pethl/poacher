class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :send_welcome_email, :notify_admin

  has_many :picksheets, foreign_key: :contact_id

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  scope :active, -> { where(account_active: true) }
  scope :ordered, -> { order(:last_name, :first_name) }

  def in_group?(key)
    groups.any? { |g| g.key == key.to_s }
  end

  # Coarse, section-level check (e.g. "can this user see the Dairy area at all") —
  # distinct from Ability's per-model can?/cannot?. Admin and Mgmt always pass, since
  # they're blanket everywhere. Used by both nav visibility and PagesController's guard,
  # so the two can never drift out of sync with each other.
  def can_access_section?(key)
    in_group?("admin") || in_group?("mgmt") || in_group?(key)
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def initials
    "#{first_name&.first}.#{last_name&.first}."
  end

  # ✅ Move the method BEFORE marking it private
  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end

  def notify_admin
    UserMailer.new_user_notification(self).deliver_later
  end

  private
  # Nothing below here unless it's meant to be private
end

