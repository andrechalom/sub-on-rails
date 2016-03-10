#   Edite este arquivo ANTES de realizar db:setup para criar as configurações iniciais do
#   aplicativo:
User.create!(login: 'admin', nome: 'Administrador Sub on Rails', 
             email: 'admin@localhost.com', 
             admin: true, password: 'segredo1234'
            )

Server.create!(singleton_guard: true,
               repo_url: "http://example.com/svn",
               has_mail: true
              )


