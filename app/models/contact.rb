class Contact < ApplicationRecord
  validate :only_one_payment_term_allowed
  has_many :picksheets, foreign_key: :contact_id

  scope :ordered, -> { order(business_name: :asc) }

  def payment_terms
    return "Pre Payment Required" if pre_payment
    return "Payment on Receipt" if payment_on_receipt
    return "#{days_after_invoice} Days After Invoice" if days_after_invoice.present? && days_after_invoice.is_a?(Integer)
  
    ""
  end

  private

  def only_one_payment_term_allowed
    filled_fields = [pre_payment, payment_on_receipt, days_after_invoice.present?].count(true)
    
    if filled_fields > 1
      errors.add(:base, "Only one payment term can be selected")
    end
  end
end 
