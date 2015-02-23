require 'rubygems'    # ←Ruby 1.9では不要
require 'twitter'
require 'pp'

  CONSUMER_KEY = 'eugILOUDrNKpnhBZ7jXrn9CoH'
  CONSUMER_SECRET = 'Aa0yrxC0tguMO5HGG3TbZDh8t4PZ4mWcZiLb9Mti0JRH13azlh'
  ACCESS_TOKEN = '3037615388-BvSd73ZvSKLBVFKj8UnZ6mvXr3hcBqpSIM6bZ24'
  ACCESS_TOKEN_SECRET = 'YHdc2G4IXb9wComlxSKYsN6yWOKOnhQBPYdmnB7wolje0'
# ログイン
 client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONSUMER_KEY
  config.consumer_secret     = CONSUMER_SECRET
  config.access_token        = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end
 #はらだ語録
 rem = ["まじで！？","ほんまそれな","しょうみだるい","ゆうていけるっしょ","ばりおもろいやん","だるいってほんまに","え、きっしょ笑","それは↑な↓いわ"]
 len = rem.length

f=open("twitter.txt","r")
last_mention=[f.gets.to_i,1].max
f.close
p last_mention

#a = client.mentions_timeline(:since_id=>last_mention)a
a = client.home_timeline(:since_id=>last_mention)
a.each {|n|
  if n.user.screen_name != "honmani_harada"
    p n.user.screen_name
    reply="@"+n.user.screen_name+" #{rem[rand(0..len-1)]}"
    client.update(reply,:in_reply_to_status_id=>n.id)
    if last_mention < n.id then
      last_mention=n.id
    end
  end
}
f=open("twitter.txt", "w")
f.puts(last_mention)
f.close

#client.mentions_timeline.each{|rep|
#  user_id = rep.user.screen_name
#  client.update("@#{user_id} ほんまそれな")
#}
