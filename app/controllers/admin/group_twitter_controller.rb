require "rubygems"
require "oauth"

class Admin::GroupTwitterController < ApplicationController
  def index
  end
  
  def auth_by_twitter
    consumer = OAuth::Consumer.new(
      Radiant::Config['CONSUMER_KEY'],
      Radiant::Config['CONSUMER_SECRET'],
      :site => "http://twitter.com"
    )
    callback = admin_group_twitter_url(:action => :callback)
    request_token = consumer.get_request_token({ :oauth_callback => callback })
    redirect_to request_token.authorize_url
  end
  
  def callback
    # Get access token
    access_token = nil
    
    if access_token
      # Save access token
      flash[:notice] = "Success"
    else
      flash[:error] = "Fail"
    end
    
    redirect_to admin_group_twitter_path    
  end
end
