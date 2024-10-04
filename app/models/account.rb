class Account < ApplicationRecord
  before_create :create_pubsub

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name email_address publisher subscriber created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["publisher", "subscriber"]
  end

  validates :name, presence: true
  validates :publisher, presence: false
  validates :subscriber, presence: false

  belongs_to :publisher, optional: true
  belongs_to :subscriber, optional: true

  private

    def create_pubsub
      publisher = Publisher.create({})
      subscriber = Subscriber.create({})
      self.publisher_id = publisher.id
      self.subscriber_id = subscriber.id
    end
end
