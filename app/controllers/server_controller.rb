class ServerController < ApplicationController
    def edit
        current_user
        if auth_admin
            @server = Server.instance
        end
    end
    def update
        current_user
        if auth_admin
            @server = Server.instance
            if @server.update params.require(:server).permit(:has_mail, :repo_url)
                redirect_to @server, notice: 'Alterações realizadas'
            else
                render 'edit'
            end
        end
    end
end
