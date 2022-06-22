class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request

    # POST /auth/login
    def login
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])
            token = jwt_encode(user_id: @user.id)
            render status: 200, json: {token: token}
        else
            render status: 401, json: {message: "No autorizado"}
        end
    end
end