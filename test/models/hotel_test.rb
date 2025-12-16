require "test_helper"

class HotelTest < ActiveSupport::TestCase
  test "hotel is valid with name and location" do
    hotel = Hotel.new(name: "Test Hotel", location: "Dublin")
    assert hotel.save
  end

  test "hotel invalid without name" do
    hotel = Hotel.new(location: "Dublin")
    assert_not hotel.save
  end
end
