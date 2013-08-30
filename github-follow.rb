require 'rest-client'
require 'io/console'
require 'json'

puts "Username: "
username = gets.chomp!

puts "Password: "
password = STDIN.noecho(&:gets).chomp!

GITHUB_URL = "https://#{username}:#{password}@api.github.com"

# get followers
r = RestClient.get GITHUB_URL + "/user/following"
followers = JSON.parse(r.to_s).map {|u| u["login"]}

# get BT members
r = RestClient.get GITHUB_URL + "/orgs/braintree/members"
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
