class Publisher < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[id created_at updated_at]
  end

  has_one :account
  has_many :subscription
end
