class Admin::TweetsController < ApplicationController
  def index
    @group_twitter_accounts = GroupTwitterAccount.find(:all)
    @tweets = Tweet.find(:all,:limit => 10,:order => "created_at DESC, id")
    @tweet = Tweet.new
  end

  def create

    user = current_user
    group_twitter_account = GroupTwitterAccount.find(params[:group_twitter_account_id])

    access_token = group_twitter_account.get_access_token

    begin
      status = params[:tweet][:body]
      res = access_token.post(
        "/statuses/update.json",
        :status => params[:tweet][:body]
      )
      obj = JSON.parse(res.body)

      attributes = {
        :user => user,
        :group_twitter_account => group_twitter_account
      }

      unless obj['id_str'].blank?
        attributes['status_id'] = obj['id_str']
        attributes['status'] = Tweet::PUBLISHED
      else
        attributes['status'] =  Tweet::FAILD
      end

    rescue
      flash[:error] = t("group_twitter.create.authentification_error")
    end

    tweet = Tweet.new(attributes.merge(params[:tweet]))
    if tweet.save
      if tweet.status == Tweet::FAILD
        flash[:error] = t("group_twitter.create.post_to_twitter_faild")
      else
        flash[:notice] = t("group_twitter.create.success")
      end
    else
      flash[:error] = t("group_twitter.create.faild")
    end
    redirect_to admin_tweets_path

  end

end
