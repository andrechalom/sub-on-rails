# Sub-on-rails

O projeto sub-on-rails é uma pequena aplicação escrita em Ruby-on-rails
para facilitar o gerenciamento de usuários de um servidor de Apache Subversion.

Ele foi escrito para gerenciar usuários no servidor da LAGE (IB/USP), mas
a instalação deve ser possível para qualquer outro servidor.

# Instalação e teste

O svn deve estar configurado para usar WebDAV, já que conexões pelos protocolos
svn e ssh+svn não aceitam autenticação customizada.

# Deploy

# Versões

Testado com Ruby 1.9.3p484, Rails 4.2.5.1, svn 1.8.8, sqlite 3.8.2.
