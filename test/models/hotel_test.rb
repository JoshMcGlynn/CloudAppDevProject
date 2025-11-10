require "test_helper"

class HotelTest < ActiveSupport::TestCase
  test "should not save hotel without name" do
    hotel = Hotel.new
    assert_not hotel.save, "Saved the hotel without a name"
  end
end
