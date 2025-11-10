class Room < ApplicationRecord
  belongs_to :hotel
  validates :number, :room_type, :price, presence: true
end
