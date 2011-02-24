require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::GroupTwitterController do
  dataset :users_and_pages

  before(:each) do
    login_as :admin
  end

  describe "#index" do
    it "render group twitter accounts" do
      get :index
      response.should be_success
      assigns[:accounts].should_not be_nil
    end
  end
  
  describe "#auth_by_twitter" do
    def setup_client
      callback = admin_group_twitter_url(:action => :callback)
      request_token = setup_mock_request_token
      @mock_client = mock("twitter_client")
      @mock_client.should_receive(:get_request_token).with(callback).and_return(request_token)
    end
        
    it "redirect to authorize_url" do
      setup_client
      controller.twitter_client = @mock_client
      get :auth_by_twitter
      response.should be_redirect
    end
    
    it "remember request token and secret on session" do
      setup_client
      controller.twitter_client = @mock_client
      get :auth_by_twitter
      session[:request_token].should_not be_nil
      session[:request_token_secret].should_not be_nil
    end
    
    it "redirect to group twitter index page when error occured" do
      mock_client = mock("twitter_client")
      callback = admin_group_twitter_url(:action => :callback)
      mock_client.should_receive(:get_request_token).with(callback).and_raise("Error")
      controller.twitter_client = mock_client
      get :auth_by_twitter
      response.should be_redirect
      response.should redirect_to(admin_group_twitter_path)
      flash[:error].should_not be_nil
    end
  end
  
  describe "#callback" do
    before do
      @mock_client = mock("twitter_client")
    end
    
    def create_mock_token
      token = setup_mock_access_token
      json='{"name": "Administrator", "profile_image_url": "http://example.com/avatar.jpg"}'
      res = mock("response")
      res.should_receive("body").and_return(json)
      token.should_receive(:get).and_return(res)
      token
    end
    
    it "require oauth token and verifier parameters" do
      get :callback
      response.status.should eql("401 Unauthorized")
    end
    
    it "redirect to admin_group_twitter_path when success" do
      @mock_client.should_receive(:get_access_token).and_return(create_mock_token)
      controller.twitter_client = @mock_client
      get :callback, :oauth_token => "oauth_token", :oauth_verifier => "oauth_verifier"
      response.should redirect_to(admin_group_twitter_path)
      flash[:notice].should_not be_nil      
    end
    
    it "create a new account" do      
      @mock_client.should_receive(:get_access_token).and_return(create_mock_token)
      controller.twitter_client = @mock_client
      lambda do
        get :callback, :oauth_token => "oauth_token", :oauth_verifier => "oauth_verifier"
        account = assigns[:group_twitter_account]
        account.should_not be_nil
        account.user_id.should_not be_nil
        account.screen_name.should_not be_nil
        account.access_token.should_not be_nil
        account.access_token_secret.should_not be_nil
        account.name.should_not be_nil
        account.profile_image_url.should_not be_nil
      end.should change(GroupTwitterAccount, :count).by(1)
    end
    
    it "find an exist account" do
      lambda do
        @mock_client.should_receive(:get_access_token).and_return(create_mock_token)
        controller.twitter_client = @mock_client
        get :callback, :oauth_token => "oauth_token", :oauth_verifier => "oauth_verifier"
        created = assigns[:group_twitter_account]
        
        @mock_client.should_receive(:get_access_token).and_return(create_mock_token)
        controller.twitter_client = @mock_client
        get :callback, :oauth_token => "oauth_token", :oauth_verifier => "oauth_verifier"
        exist = assigns[:group_twitter_account]
        
        exist.should eql(created)
      end.should change(GroupTwitterAccount, :count).by(1)
    end
    
    it "redirect to group twitter index page when error occured" do
      @mock_client.should_receive(:get_access_token).and_raise("Error")
      controller.twitter_client = @mock_client
      get :callback, :oauth_token => "oauth_token", :oauth_verifier => "oauth_verifier"
      response.should be_redirect
      response.should redirect_to(admin_group_twitter_url)
      flash[:error].should_not be_nil
    end
  end
end