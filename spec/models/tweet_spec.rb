require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'pp'

describe Tweet do
  dataset :users
  
  describe "#user" do
    it "belongs to user" do
      tweet = create_tweet
      tweet.user.should_not be_nil
    end
  end
  
  describe "#create" do
    it "create a new tweet" do
      tweet = create_tweet
      tweet.should be_valid
    end
    
    it "require user" do
      tweet = create_tweet(:user => nil)
      tweet.should_not be_valid
    end
    
    it "require body" do
      tweet = create_tweet(:body => "")
      tweet.should_not be_valid
    end    
  end
  
  describe "#publihed?" do
    it "could be published" do
      tweet = create_tweet
      tweet.should be_published
    end
    
    it "could not be published" do
      tweet = create_tweet(:body => nil, :status => nil)
      tweet.should_not be_published
    end
  end
    
  def create_tweet(params = {})
    opts = { :user => users(:admin), :body => "Body", :status => 1}
    Tweet.create(opts.merge(params))
  end
end