class UsersController < ApplicationController
    def new
        route :new
    end

    def create
        @user = User.new(user_params)
        if @user.save 
            route_to cats_url
        else
            route :new 
        end
    end

    def user_params 
        params.require(:user).permit(:username, :password_digest, :session_token)
    end
end