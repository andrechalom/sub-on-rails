# encoding: UTF-8
class UsersController < ApplicationController
    # Catches RecordNotFound
    around_filter :catch_not_found

    def new
        @user = User.new
    end
    def index
        @users = User.all
    end
    def show
        @user = User.find(params[:id])
    end
    def edit
        @user = User.find(params[:id])
    end
    def create
        @user = User.new(user_params)

        if @user.save
            redirect_to @user
        else
            render 'new'
        end
    end
    def update
        @user = User.find(params[:id])

        if @user.update(user_params)
            redirect_to @user
        else
            render 'edit'
        end
    end
    def destroy
        @user = User.find(params[:id])
        @user.destroy

        redirect_to users_path
    end
    private

    def user_params
        params.require(:user).permit(:nome, :login, :email, :admin, :password)
    end

    def catch_not_found
          yield
    rescue ActiveRecord::RecordNotFound
            redirect_to users_path, flash: {notice: "Usuário não localizado"}
    end
end
