class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         def email_required?
          false
        end

  has_many :picksheets, foreign_key: :contact_id

  def full_name
    "#{first_name} #{last_name}".strip
  end

end 
