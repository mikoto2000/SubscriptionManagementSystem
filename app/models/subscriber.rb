class Subscriber < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[name email_address id created_at updated_at]
  end

  before_save { self.email_address = email_address.downcase }

  has_one :account
  has_one :subscription

  validates :name, presence: true
  validates :email_address,
    presence: true,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_insensitive: true }
end
