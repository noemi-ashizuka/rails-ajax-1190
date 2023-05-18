class Review < ApplicationRecord
  belongs_to :restaurant # creates a method -> review.restaurant
  validates :content, presence: true
end
