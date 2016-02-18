# encoding = UTF-8
class AuthenticationController < ApplicationController
    layout "signin" # Essentially a copy of default layout, w/o the log in box
    def signin
        @user = User.new
        session[:return_to] ||= request.referer
    end
    def login
        @user = User.find_by_login(params[:user][:login])
        if @user
            @user = @user.authenticate(params[:user][:password])
            if @user
                session[:user_id] = @user.id
                redirect_to session[:return_to] and return
            end
        end 
        # if arrives here, authentication has failed
        redirect_to root_path, notice: "Usuário ou senha inválidos"
    end
    def logout
        session[:user_id] = nil
        redirect_to root_path and return
    end
end
