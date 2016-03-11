#!/usr/bin/env ruby
require "mysql2"
require "bcrypt"
# Le usuario e senha do stdin
user = gets.chomp
password = gets.chomp
# Gera o request diretamente para o banco de dados
client = Mysql2::Client.new(host: "localhost", username: "subonrails", password: "", database: "subonrails_dev")
statement = client.prepare("SELECT password_digest as pw FROM users WHERE login = ? AND user_id IS NOT NULL")
result = statement.execute(user)
result.each do |row|
    if BCrypt::Password.new(row["pw"]) == password
        puts "sub-on-rails authorization log user #{user} authorized"
        exit(0)
    end
end
puts "sub-on-rails authorization log user #{user} NOT authorized"
exit(1)
