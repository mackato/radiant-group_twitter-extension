require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::CommentsController do
  dataset :users_and_pages
  before(:each) do
    login_as :admin
    @tweet = Tweet.create!(:user => users(:admin), :body => "Body")
  end

  describe "routing" do
    it "should route to index by default" do
      params_from(:get, admin_tweets_path).should == {
        :controller => "admin/tweets", :action => "index"
      }
    end 
    
    it "should route to post a tweet" do
      params_from(:post, admin_tweets_path).should == {
        :controller => "admin/tweets", :action => "create"
      }
    end
    
    it "should route to a tweet page" do
      params_from(:get, admin_tweet_path(@tweet)).should == {
        :controller => "admin/tweets", :action => "show", :id => @tweet.id.to_s
      }
    end
  end
end