# encoding:utf-8
require 'rubygems'    # ←Ruby 1.9では不要
require 'twitter'
require 'tweetstream'
require 'pp'

# ログイン
 client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONSUMER_KEY
  config.consumer_secret     = CONSUMER_SECRET
  config.access_token        = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end
 client_stream = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = CONSUMER_KEY
  config.consumer_secret     = CONSUMER_SECRET
  config.access_token        = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end
  TweetStream.configure do |config|
    config.consumer_key = CONSUMER_KEY
    config.consumer_secret = CONSUMER_SECRET
    config.oauth_token = ACCESS_TOKEN
    config.oauth_token_secret = ACCESS_TOKEN_SECRET
    config.auth_method = :oauth
  end
fav = ["まじで！？しょうみおもんないやろｗ"]
  @timeline = TweetStream::Client.new


#ファボられに反応
  client_stream.user do |object|
  File.open("./fwords.txt","r:utf-8") do |f|
    #各行読み込み
    f.each_line do |line|
      #語録更新
      fav.push(line[0,line.length-1])
    end
  end
    object_name =  object.name.to_s if object.is_a?(Twitter::Streaming::Event)
    object_source =  object.source.screen_name if object.is_a?(Twitter::Streaming::Event)
    if object.is_a?(Twitter::Streaming::Event) && object_name == "favorite" && object_source != "honmani_harada"
      client.update("@#{object_source} #{fav[rand(0..fav.length-1)]}")
    end
  end
