#!/usr/bin/env ruby
# coding:utf-8
 
require './bot.rb'
 
bot = Bot.new
 
begin
  bot.timeline.userstream do |status|
 
    twitter_id = status.user.screen_name
    name = status.user.name
    contents = status.text
    status_id = status.id

    status do |a|
      p a
    end
 
    # リツイート以外を取得
    if !contents.index("RT")
      str_time = Time.now.strftime("[%Y-%m-%d %H:%M]")
 
      # botを呼び出す(他人へのリプを無視)
      if !(/^@\w*/.match(contents))
        if contents =~ /おーい/
          text = "はい\n#{str_time}"
          bot.retweet(status_id:status_id)
          bot.post(text,twitter_id:twitter_id,status_id:status_id)
        end
      end
 
      # 自分へのリプであれば
      if contents =~ /^@honmani_harada\s*/
        if contents =~ /ほげ/
          text = "ほげほげ\n#{str_time}"
          bot.fav(status_id:status_id)
          bot.post(text,twitter_id:twitter_id,status_id:status_id)
        end
      end
    end
    sleep 2
  end
 
rescue => em
  puts Time.now
  p em
  sleep 2
  retry
 
rescue Interrupt
  exit 1
end
