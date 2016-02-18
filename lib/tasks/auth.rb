#!/usr/bin/env ruby
require "net/http"
require "uri"
# Le usuario e senha do stdin
user = gets.chomp
password = gets.chomp
# Gera o request para o controle authentication#authx
uri = URI.parse("http://localhost:3000/authx?login=#{user}&password=#{password}")
http = Net::HTTP.new(uri.host, uri.port)
response = http.request(Net::HTTP::Get.new(uri.request_uri))
puts "sub-on-rails authorization log user #{user} status #{response.code}"
if response.code.to_i == 200 then exit (0) else exit (1) end
