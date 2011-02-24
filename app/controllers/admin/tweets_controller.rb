class Admin::TweetsController < ApplicationController
  def index
    @group_twitter_accounts = GroupTwitterAccount.find(:all)
    @tweets = Tweet.find(:all,:limit => 10,:order => "created_at DESC, id")
    @tweet = Tweet.new
  end

  def save
    user = current_user
    group_twitter_account = GroupTwitterAccount.find(params[:group_twitter_account_id])
    attributes = {:user => user,:group_twitter_account => group_twitter_account}
    tweet = Tweet.new(attributes.merge(params[:tweet]))

    if tweet.save!
      flash[:notice] = "success"
      redirect_to admin_tweets_path
    else
      flash[:error] = "faild"
      redirect_to admin_tweets_path
    end
  end
end
