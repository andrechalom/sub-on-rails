# encoding = UTF-8
class AuthenticationController < ApplicationController
    def signin
        @user = User.new
    end
    def login
        @user = User.find_by_login(params[:user][:login])
        if @user
            @user = @user.authenticate(params[:user][:password])
            if @user
                session[:user_id] = @user.id
                redirect_to root_path and return
            end
        end 
        # if arrives here, authentication has failed
        redirect_to root_path, notice: "Usuário ou senha inválidos"
    end
    def logout
        session[:user_id] = nil
    end
end
