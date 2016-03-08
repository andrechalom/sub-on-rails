![Sub on rails](public/sub_logo.png?raw=true)

**IMPORTANTE!** O Sub on Rails é um projeto em versão pré-alpha! Não instale ele (ainda!)

O projeto Sub on Rails é uma pequena aplicação escrita em Ruby on Rails
para facilitar o gerenciamento de usuários de um servidor de Apache Subversion.

Ele foi escrito para gerenciar usuários nos servidores do Instituto de Biociências (IB/USP), mas
a instalação deve ser possível para qualquer outro servidor.

# Requisitos
O subversion pode usar três métodos para servir conteúdo: svnserve (protocolo svn),
svnserve sobre túnel ssh (protocolo svn+ssh) ou Apache WebDAV (protocolos http e 
https). Destes, apenas o protocolo WebDAV aceita autorização customizada, então
este é o único método que usamos no Sub-on-Rails.

# Instalação
Antes de mais nada, é necessário instalar e configurar o Subversion, o servidor 
Apache e uma instalação de Ruby (preferencialmente por rvm). Crie um repositório svn,
por exemplo em /var/svn/repos. Certifique-se de que o usuário no qual o Apache está rodando
(como www-data) tem permissão de leitura e escrita no repositório.

Os seguintes módulos de Apache são essenciais para o funcionamento do Sub on Rails:
- auth_basic
- authnz_external
- dav
- dav_svn

Os seguintes módulos de Apache podem ser úteis:
- rewrite
- proxy
- proxy_http

Instale também um
banco de dados (a versão de desenvolvimento usa SQLite3, mas é simples migrar 
para outro banco). Faça o download do código fonte e execute 
`bundle install` na raíz (execute como um usuário comum 
- se for necessário sudo o próprio bundle irá solicitar
a senha). A seguir, compile o Passenger com
`passenger-install-apache2-module`. Siga as instruções para configurar o Passenger.

**Importante:** os arquivos do Sub on Rails devem ficar fora da área normalmente
servida pelo Apache (como /var/www/html). Crie um diretório à parte para o Sub on Rails,
e utilize as diretivas abaixo para permitir o acesso apenas pelo Passenger. Por exemplo,
você pode clonar este projeto como /var/svn/sub-on-rails

## Configuração do Apache
Há duas configurações importantes de serem feitas no servidor de http: habilitar o
Passenger para servir apps escritos em Rails, e configurar o Apache para
solicitar autenticação ao acessar o repositório svn. Siga as instruções do 
Passenger para habilita-lo. Para configurar o acesso do repositório svn,
inclua as seguintes diretivas:

``` 
AddExternalAuth auth /var/svn/sub-on-rails/lib/tasks/auth.rb
SetExternalAuthMethod auth pipe
<Location /svn>
    DAV svn
    SVNPath /var/svn/repos
    AuthName "Sub-on-rails"
    AuthType Basic
    AuthBasicProvider external
    AuthExternal auth
    Require valid-user
</Location>
```

Lembre-se de trocar os caminhos para os arquivos no exemplo acima se você não instalou
o repositório / aplicativo onde sugerido.

Para habilitar leitura anônima e exigir autenticação somente para escrita (commits), 
substitua o "require valid-user" por 
```
<LimitExcept GET PROPFIND OPTIONS REPORT>
    Require valid-user
</LimitExcept>
```

O Passenger precisa de um VirtualHost próprio, então você pode criar algo como
```
<VirtualHost *:4000>
ServerName myserver.example.com
DocumentRoot /var/svn/sub-on-rails/public
</VirtualHost>
```

E, se desejar, pode habilitar o proxy na porta 80 para redirecionar o subonrails
de forma transparente para a porta 4000:

```
RewriteEngine on
RewriteRule ^/subonrails$ http://localhost:4000/subonrails [P]
RewriteRule ^/subonrails/(.*) http://localhost:4000/subonrails/$1 [P]
```

Se você alterar a configuração de proxy ou a porta na qual o passenger está conectado,
lembre-se de alterar o routes.rb e a URI em lib/tasks/auth.rb!

## Deploy
Depois de todas as configurações acima, o deploy do Sub on Rails é bastante simples:
configure o arquivo de routes.rb com o prefixo escolhido (por exemplo, /subonrails);
configure o serviço de e-mail em config/environments/production (use o de desenvolvimento
como base); e adicione as variáveis de ambiente necessárias (senha de e-mail e secret_key).

A instalação inicial contém a instrução para gerar um usuário "admin", com nome, e-mail e senha
definidos no arquivo `db/seeds.rb`. Antes de prosseguir, edite esse arquivo para customizar
o seu usuário administrador.

Finalmente, crie o banco de dados do ambiente de produção, e compile os recursos (css/js) com
`
export RAILS_ENV=production 
rake db:setup
rake assets:precompile
`

# Versões

Testado com Ruby 2.2.1, Rails 4.2.5.1, svn 1.8.8, sqlite 3.8.2.
