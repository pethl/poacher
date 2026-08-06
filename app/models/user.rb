class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :send_welcome_email, :notify_admin
  has_one :staff, inverse_of: :user

  has_many :picksheets, foreign_key: :contact_id

  scope :active, -> { where(account_active: true) }
  scope :ordered, -> { order(:last_name, :first_name) }

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

