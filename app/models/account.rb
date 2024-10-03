class Account < ApplicationRecord
  before_create :create_pubsub

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def self.ransackable_attributes(_auth_object = nil)
    %w[id created_at updated_at]
  end

  validates :name, presence: true

  belongs_to :publisher
  belongs_to :subscriber

  private

    def create_pubsub
      publisher = Publisher.create({})
      subscriber = Subscriber.create({})
      self.publisher_id = publisher.id
      self.subscriber_id = subscriber.id
    end
end
