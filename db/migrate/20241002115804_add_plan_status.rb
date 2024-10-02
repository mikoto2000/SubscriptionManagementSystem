class AddPlanStatus < ActiveRecord::Migration[7.2]
  def change

    add_reference :plans, :plan_status, foreign_key: true

  end
end
