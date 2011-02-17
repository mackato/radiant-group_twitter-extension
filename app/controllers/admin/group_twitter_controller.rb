require "rubygems"
require "oauth"

class Admin::GroupTwitterController < ApplicationController
  def self.consumer
    consumer = OAuth::Consumer.new(
      Radiant::Config['CONSUMER_KEY'],
      Radiant::Config['CONSUMER_SECRET'],
      :site => "http://twitter.com"
    )
  end


  def index
    @account = GroupTwitterAccount.find(:first)
  end
  
  def auth_by_twitter
    consumer = OAuth::Consumer.new(
      Radiant::Config['CONSUMER_KEY'],
      Radiant::Config['CONSUMER_SECRET'],
      :site => "http://twitter.com"
    )
    callback = admin_group_twitter_url(:action => :callback)
    request_token = consumer.get_request_token({ :oauth_callback => callback })

    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret

    redirect_to request_token.authorize_url
  end
  
  def callback
    consumer = Admin::GroupTwitterController.consumer

    request_token = OAuth::RequestToken.new(
      consumer,
      session[:request_token],
      session[:request_token_secret]
    )
    # Get access token
    access_token = request_token.get_access_token(
      {},
      :oauth_tokene => params[:oauth_token],
      :oauth_verifier => params[:oauth_verifier]
    )

    group_twitter_account = GroupTwitterAccount.new(
      :user_id => access_token.params[:user_id],
      :screen_name => access_token.params[:screen_name], 
      :access_token => access_token
    )
    if access_token 
      # Save access token
      group_twitter_account.get_user_info
      if group_twitter_account.save
        flash[:notice] = "Success in Twitter Account registration"
      end
    else
      flash[:error] = "Fail in Twitter OAuth"
    end
    redirect_to admin_group_twitter_path    
  end

  def delete_twitter_account
    group_twitter_account = GroupTwitterAccount.find(:first)
    if group_twitter_account.delete
      flash[:notice] = "Twitter Account registration deleted."
    end
    redirect_to admin_group_twitter_path
  end
end
