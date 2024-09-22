class Plan < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[publisher_id name cost id created_at updated_at]
  end

  validates :publisher, uniqueness: { scope: :name }

  belongs_to :publisher
end
