require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
    setup do
        @user = User.create!(
            email: "login@test.com",
            password: "password123",
            password_confirmation: "password123"
        )
    end

    test "login succeeds with valid credentials" do
        post "/login", params: {
            email: "login@test.com",
            password: "password123"
        }

        assert_response :success
    end

    test "login fails with invalid password" do
        post "/login", params: {
            email: "login@test.com",
            password: "wrongpassword"
        }

        assert_response :unauthorized
    end
end
