class CommissionMaster < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[from_date to_date commission_fee id created_at updated_at]
  end
end
