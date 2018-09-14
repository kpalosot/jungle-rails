class Review < ActiveRecord::Base
  belongs_to :product
  belongs_to :user

  validates :description, presence: true
  validates :product_id, presence: true
  validates :user_id, presence: true
  validates :rating, presence: true,
            numericality: {
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 5
            }
end
