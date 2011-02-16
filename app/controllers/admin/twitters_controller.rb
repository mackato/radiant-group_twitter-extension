require "twitter"

class Admin::TwittersController < ApplicationController
  def index
    @user = Twitter.find(:first)
    #@user = Twitter.new(:screen_name => "sea_mountain")
  end

  def oauth
    CONSUMER_KEY = ""
    CONSUMER_SECRET = ""
    consumer = OAuth::Consumer.new(
      CONSUMER_KEY,
      CONSUMER_SECRET,
      :site => "http://twitter.com"
    )
    optprm = { :oauth_callback => "http://localhost:3000/admin/twitter"}
    request_token = consumer.get_request_token(optprm,{})

    prm = { :oauth_verifier => oauth_vrfy }
    @access_token = request_token.get_access_token(prm)
  end
end
