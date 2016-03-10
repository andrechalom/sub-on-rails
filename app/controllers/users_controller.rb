# encoding: UTF-8
class UsersController < ApplicationController
    # Catches RecordNotFound
    around_filter :catch_not_found

    def new
        @user = User.new
    end
    def index
        @users = User.all.order :login
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
            # Sends a welcome mail
            begin
                ApplicationMailer.welcomeMail(@user).deliver_now
            rescue Errno::ECONNREFUSED
                flash.alert = "Houve um erro ao enviar um e-mail" 
            end
            redirect_to @user, notice: "Usuário criado com sucesso. Aguarde a autorização de um administrador para usar o sistema."
        else
            render 'new'
        end
    end
    def update
        current_user ## Ensures curent user is set
        authorized = nil
        @user = User.find(params[:id])
        if @user == @current_user or auth_admin ### LAZY IF!
            ####### Pretty non-standard update for "authorized"
            #### should be moved to Model?
            if @current_user.admin
                if @user.authorized and params[:user][:authorized] == "0" # revoking
                    @user.user_id = nil
                end
                if (!@user.authorized) and (params[:user][:authorized] == "1") #authorizing
                    @user.user_id = @current_user.id
                    authorized = true
                end
            end
            if @user.update(user_params)
                if authorized
                    begin
                        ApplicationMailer.authMail(@user).deliver_now
                    rescue Errno::ECONNREFUSED
                        flash.alert = "Houve um erro ao enviar um e-mail" 
                    end
                end
                redirect_to @user
            else
                render 'edit'
            end
        end
    end
    def destroy
        if auth_admin
            @user = User.find(params[:id])
            @user.destroy

            redirect_to users_path
        end
    end
    private

    def user_params
        ## Qualquer edicao proibida eh silenciosamente ignorada
        if @user
            if @current_user and @current_user.admin #LAZY IF
                # Apenas admins podem dar e retirar status de admin
                params.require(:user).permit(:nome, :email, :admin, :password)
            else
                # Um usuario pode trocar o proprio nome, email, password
                params.require(:user).permit(:nome, :email, :password)
            end
        else # cadastrando
            params.require(:user).permit(:nome, :login, :email, :password)
        end
    end

    def catch_not_found
        yield
    rescue ActiveRecord::RecordNotFound
        redirect_to users_path, alert: "Usuário não localizado."
    end
end
