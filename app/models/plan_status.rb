class PlanStatus < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[name id created_at updated_at]
  end
end
