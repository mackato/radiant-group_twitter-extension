require "rubygems"
require "oauth"

class GroupTwitterAccount < ActiveRecord::Base
  def self.consumer
    consumer = OAuth::Consumer.new(
      Radiant::Config['CONSUMER_KEY'],
      Radiant::Config['CONSUMER_SECRET'],
      :site => "http://twitter.com"
    )
  end

  def get_user_info(access_token)
    #access twitter API
  end


end
