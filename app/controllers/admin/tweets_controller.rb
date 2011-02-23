class Admin::TweetsController < ApplicationController
  def index
    @tweets = Tweet.find(:all,:limit => 10)
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(params[:tweet])

    if @tweet.save
      flash[:notice] = "success"
      redirect_to admin_tweets_path
    else
      render :action => "index"
    end
  end
end
