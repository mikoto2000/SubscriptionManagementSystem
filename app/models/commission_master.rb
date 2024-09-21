class CommissionMaster < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[from_date to_date commission_fee id created_at updated_at]

  end

  validates :from_date, presence: true
  validates :to_date, presence: true
  validates :commission_fee, presence: true
  validate :no_overlap

  private

    # 他に重複する期間を持つレコードがが無いかをチェック
    def no_overlap
      overlap_record = CommissionMaster
            .where('from_date <= ?', to_date)
            .where('to_date >= ?', from_date)

      overlap_record = overlap_record.where.not(id: id) if id.present?

      if overlap_record.exists?
        errors.add(:base, 'この期間は他の期間と重複しています。');
      end
    end
end
