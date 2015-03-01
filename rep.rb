require 'rubygems'    # ←Ruby 1.9では不要
require 'twitter'
require 'tweetstream'
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
 
  @timeline = TweetStream::Client.new

 #はらだ語録
  rem = ["ほんまそれな"]
  fav = ["おっｗふぁぼやんｗほんまにありがとうなｗ"]

  File.open("./words.txt","r:utf-8") do |f|
    #各行読み込み
    f.each_line do |line|
      #語録更新
      rem.push(line[0,line.length-1])
    end
  end
  File.open("./fwords.txt","r:utf-8") do |f|
    #各行読み込み
    f.each_line do |line|
      #語録更新
      fav.push(line[0,line.length-1])
    end
  end


  @timeline.userstream do |status|
    twitter_id = status.user.screen_name
    name = status.user.name
    contents = status.text
    status_id = status.id

    #自分のツイートは除外する
    if twitter_id == "honmani_harada" then
      p "自分のツイートには絡まない"
      next
    end

    #リプライに反応
    if contents =~ /^@honmani_harada\s*/ then
      #リプ語録登録フォーマットの形か否か
      if contents =~ /^@honmani_harada\s*\?|^@honmani_harada\s*\？/ then
        newword = contents[17..contents.length]
        p newword
        #はらだくん学習
        rem.push(newword)
        #words.txt更新
        File.open("./words.txt","a:utf-8") do |f|
          f.puts(newword)
        end
        client.update("@"+twitter_id+" "+newword + " 了解んご また話そうや", :in_reply_to_status_id=>status_id)
      #ファボ語録用フォーマットか否か
      elsif contents =~ /^@honmani_harada\s*\!|@honmani_harada\s*！/ then
        newword = contents[17..contents.length]
        p newword
        #はらだくん学習
        fav.push(newword)
        #fwords.txt更新
        File.open("./fwords.txt","a:utf-8") do |f|
          f.puts(newword)
        end
        client.update("@"+twitter_id+" "+"\"" + newword + "\"" + " 了解んご またふぁぼってや", :in_reply_to_status_id=>status_id)
      else
        reply="@"+twitter_id+" #{rem[rand(0..rem.length-1)]}"
        client.update(reply,:in_reply_to_status_id=>status_id)
      end


    #リプライ以外にもたまに雑絡み

    #普通に絡む
    elsif rand(1..5) == 1 then
      reply="@"+twitter_id+" #{rem[rand(0..rem.length-1)]}"
      client.update(reply,:in_reply_to_status_id=>status_id)

    #勝手に学習するとき
    elsif rand(1..5) == 2 then
      #誰かへのリプのとき
      if contents =~ /^@\w*/ then
        #本文取り出し
        idlen = contents.split(' ')[0].length
        newword = contents[idlen+1..contents.length-1]
        #はらだくん学習
        rem.push(newword)
        #words.txt更新
        File.open("./words.txt","a:utf-8") do |f|
          f.puts(newword)
          client.update("@" + twitter_id + " " + "\"" +newword + "\"" + " それおもろいな 俺も使うわ", :in_reply_to_status_id=>status_id)
        end
      #RTは無視する
      elsif contents =~ /^RT/ then
        p "RTには絡まない"
      #リプでもRTでもないツイートを奪う
      else
        newword = contents
        p newword
        #はらだくん学習
        rem.push(newword)
        #words.txt更新
        File.open("./words.txt","a:utf-8") do |f|
          f.puts(newword)
          client.update("@"+twitter_id + " " + "\"" + newword + "\"" + " それおもろいな 俺も使うわ", :in_reply_to_status_id=>status_id)
        end
      end
    #何もしない時
    else
      p "何もしない"
    end
  end

=begin
a = client.mentions_timeline(:since_id=>last_mention)
client.home_timeline(:since_id=>last_mention) do |n|
 if n.user.screen_name != "honmani_harada"
    p n.user.screen_name
    reply="@"+n.user.screen_name+" #{rem[rand(0..len-1)]}"
    client.update(reply,:in_reply_to_status_id=>n.id)
    if last_mention < n.id then
      last_mention=n.id
    end
  end
end
=end


#client.mentions_timeline.each{|rep|
#  user_id = rep.user.screen_name
#  client.update("@#{user_id} ほんまそれな")
#}
