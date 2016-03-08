# encoding: UTF-8
class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    helper_method :current_user

    private
    # Finds the User with the ID stored in the session with the key
    # :current_user_id This is a common way to handle user login in
    # a Rails application; logging in sets the session value and
    # logging out removes it.
    def current_user
        @current_user ||= session[:user_id] &&
            User.find_by(id: session[:user_id])
    end
    ### Maybe we should move this to the auth class?? But how?
    def auth_admin
        if auth_login # Eh necessario estar logado para ser admin
            return true if @current_user.admin
            redirect_to :back, alert: "Sua conta de usuário não tem os privilégios necessários para realizar essa operação." and return false
        end
    end
    def auth_login
        current_user # Makes sure @current_user is set
        return true if @current_user

        redirect_to :back, alert: "Você precisa estar logado para realizar essa ação." and return false
    end
end
