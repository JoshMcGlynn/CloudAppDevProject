require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user with password" do
    user = User.new(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.save
    assert user.authenticate("password123")
  end

  test "invalid without email" do
    user = User.new(password: "password", password_confirmation: "password")
    assert_not user.save
  end
  
end


