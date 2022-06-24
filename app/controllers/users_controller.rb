class UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:index, :create]
    before_action :set_user, only: [:show, :update, :destroy]

    # GET /users
    def index 
        @users = User.all
        render status: 200, json: {users: @users} 
    end

    # GET /users/:id
    def show 
        render status: 200, json: {user: @user} 
    end

    # POST /users
    def create 
        @user = User.new(user_params)
        if @user.save
            render status: 201, json: {user: @user}
        else
            render status: 400, json: {message: @user.errors.details}
        end
    end

    # PATCH/PUT users/:id
    def update
        if @user.update(user_params)
            render status: 200, json: {user: @user}
        else
            render status: 400, json: {message: @user.errors.details}
        end
    end

    # DELETE /users/:id
    def destroy
        if @user.destroy
            render status: 200, json: {message: "Usuario borrado correctamente"}
        else
            render status: 400, json: {message: @user.errors.details}
        end
    end

    private 

    def user_params
        params.permit(:name, :username, :email, :password)
    end

    def set_user
        @user = User.find(params[:id])

        return if @user.present?

        render status: 404, json: {message: "No se encontró el usuario"}
        false
    end
end