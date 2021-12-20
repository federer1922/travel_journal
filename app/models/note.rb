class Note < ApplicationRecord
  belongs_to :user

  validates :city, :description, presence: true 
  validates :description, length: { maximum: 140 }
end