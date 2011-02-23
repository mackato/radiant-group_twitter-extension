require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'pp'

describe GroupTwitterAccount do
  describe "#create" do
    it "create a new twitter account" do
      account = create_group_twitter_account
      account.should_not be_nil
      account.should be_valid
    end
    
    it "require user_id" do
      account = create_group_twitter_account(:user_id => nil)
      account.should_not be_valid
      account.errors.on(:user_id).should_not be_nil
    end
    
    it "require screen_name" do
      account = create_group_twitter_account(:screen_name => "")
      account.should_not be_valid
      account.errors.on(:screen_name).should_not be_nil
    end
    
    it "require access_token" do
      account = create_group_twitter_account(:access_token => "")
      account.should_not be_valid
      account.errors.on(:access_token).should_not be_nil
    end
    
    it "require access_token_secret" do
      account = create_group_twitter_account(:access_token_secret => "")
      account.should_not be_valid
      account.errors.on(:access_token_secret).should_not be_nil
    end
    
    it "should have unique user_id" do
      account1 = create_group_twitter_account
      account2 = create_group_twitter_account(:user_id => account1.user_id)
      account2.should_not be_valid
      account2.errors.on(:user_id).should_not be_nil
    end
  end
    
  def create_group_twitter_account(params = {})
    GroupTwitterAccount.create({
      :user_id => 101,
      :screen_name => "admin",
      :name => "Admin",
      :profile_image_url => "http://example.com/foo.jpg",
      :access_token => "abcdefg",
      :access_token_secret => "hijklmn"
    }.merge(params))
  end  
end