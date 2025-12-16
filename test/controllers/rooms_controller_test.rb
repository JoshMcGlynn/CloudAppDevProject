require "test_helper"

class RoomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hotel = Hotel.create!(name: "Room Hotel", location: "Cork")
    @user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    post "/login", params: {
      email: @user.email,
      password: "password123"
    }
  end

  test "create room" do
    assert_difference("@hotel.rooms.count", 1) do
      post hotel_rooms_path(@hotel), params: {
        room: {
          number: "101",
          room_type: "Single",
          price: 99.99,
          hotel_id: @hotel.id
        }
      }
    end

    assert_response :created
  end
end