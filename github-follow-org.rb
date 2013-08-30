require 'rubygems'
require 'bundler/setup'

require 'rest-client'
require 'io/console'
require 'json'

def error(msg)
  puts msg
  exit
end

puts "Username: "
username = gets.chomp!

puts "Password: "
password = STDIN.noecho(&:gets).chomp!

puts "Org to follow: "
org = gets.chomp!

GITHUB_URL = "https://#{username}:#{password}@api.github.com"

# get followers
begin
  r = RestClient.get GITHUB_URL + "/user/following"
rescue
  error("Bad credentials!")
end

followers = JSON.parse(r.to_s).map {|u| u["login"]}

# get BT members
begin
  r = RestClient.get GITHUB_URL + "/orgs/#{org}/members"
rescue
  error("Org '#{org} not found!")
end
members = JSON.parse(r.to_s).map {|u| u["login"]}

# follow members
members.each do |member|
  if followers.include? member
    puts "Already following #{member}"
  else
    r = RestClient.put GITHUB_URL + "/user/following/#{member}", {}
    puts "Now following #{member}"
  end
end
