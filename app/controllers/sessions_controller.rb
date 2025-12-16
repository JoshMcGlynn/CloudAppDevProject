class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create 
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
            render json: {message: "Login successful"}
        else
            render json: {error: "Invalid credentials"}, status: :unauthorized
        end
    end
end