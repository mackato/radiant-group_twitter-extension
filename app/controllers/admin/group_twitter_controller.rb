require "json"

class Admin::GroupTwitterController < ApplicationController
  attr_accessor :twitter_client

  def index
    @accounts = GroupTwitterAccount.find(:all)
  end
  
  def auth_by_twitter
    @twitter_client ||= TwitterClient.new
    callback = admin_group_twitter_url(:action => :callback)
    request_token = @twitter_client.get_request_token(callback)
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url
  rescue => e
    logger.error(e.message)
    flash[:error] = t("group_twitter.auth_by_twitter.error")
    redirect_to admin_group_twitter_path
  end
  
  def callback
    if params[:oauth_token].blank? or params[:oauth_verifier].blank?
      render :text => t("group_twitter.callback.few_parameters"), :status => 401 and return
    end

    @twitter_client ||= TwitterClient.new
    access_token = @twitter_client.get_access_token(
      session[:request_token],
      session[:request_token_secret],
      params[:oauth_token],
      params[:oauth_verifier]
    )
    
    session.delete(:request_token)
    session.delete(:request_token_secret)
    
    if access_token
      access_token_params = access_token.params
      res = access_token.get("/users/show.json?user_id=#{access_token_params[:user_id]}")
      obj = JSON.parse(res.body)
      params = {
        :user_id => access_token_params[:user_id],
        :name => obj["name"],
        :profile_image_url => obj["profile_image_url"],
        :screen_name => access_token_params[:screen_name],
        :access_token => access_token.token,
        :access_token_secret => access_token.secret
      }
      @group_twitter_account = GroupTwitterAccount.find_by_user_id(params[:user_id])
      if @group_twitter_account
        @group_twitter_account.update_attributes(params)
      else
        @group_twitter_account = GroupTwitterAccount.create!(params)
      end
    end
    
    flash[:notice] = t("group_twitter.callback.notice")
    redirect_to admin_group_twitter_path
  rescue => e
    logger.error(e.message)
    flash[:error] = t("group_twitter.callback.error")
    redirect_to admin_group_twitter_url
  end

  def delete_twitter_account
    group_twitter_account = GroupTwitterAccount.find(:first)
    if group_twitter_account.delete
      flash[:notice] = "Twitter Account registration deleted."
    end
    redirect_to admin_group_twitter_path
  end
end
