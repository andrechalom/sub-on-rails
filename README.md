# Sub on Rails

O projeto Sub on Rails é uma pequena aplicação escrita em Ruby on Rails
para facilitar o gerenciamento de usuários de um servidor de Apache Subversion.

Ele foi escrito para gerenciar usuários no servidor da LAGE (IB/USP), mas
a instalação deve ser possível para qualquer outro servidor.

# Instalação
Antes de mais nada, é necessário instalar e configurar o Subversion, o servidor 
Apache e uma instalação de Ruby (preferencialmente por rvm). Instale também um
banco de dados (usamos SQLite3, mas é simples migrar para outro banco).
Faça o download do código fonte e execute 
`bundle install` na raíz (execute como um usuário comum 
- se for necessário sudo o próprio bundle irá solicitar
a senha). A seguir, compile o Passenger com
`passenger-install-apache2-module`. Siga as instruções para configurar o Passenger.

# Deploy

O subversion pode usar três métodos para servir conteúdo: svnserve (protocolo svn),
svnserve sobre túnel ssh (protocolo svn+ssh) ou Apache WebDAV (protocolos http e 
https). Destes, apenas o protocolo WebDAV aceita autorização customizada, então
este é o único método que usamos no Sub-on-Rails.

``` 
AddExternalAuth auth /home/chalom/git/sub-on-rails/lib/tasks/auth.rb
SetExternalAuthMethod auth pipe
<Location /svn>
    DAV svn
    SVNPath /home/chalom/svn/repos
    AuthName "Sub-on-rails"
    AuthType Basic
    AuthBasicProvider external
    AuthExternal auth
    require valid-user
</Location>
```


# Versões

Testado com Ruby 1.9.3p484, Rails 4.2.5.1, svn 1.8.8, sqlite 3.8.2.
