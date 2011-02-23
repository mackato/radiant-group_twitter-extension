require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::GroupTwitterController do
  dataset :users_and_pages

  before(:each) do
    login_as :admin
  end

  describe "requesting 'index' with GET" do
    it "shows group twitter accounts" do
      get :index
      response.should be_success
      assigns[:accounts].should_not be_nil
    end
  end
  
  describe "requesting 'auth_by_twitter' with GET" do
    def setup_client
      callback = admin_group_twitter_url(:action => :callback)
      request_token = setup_mock_request_token
      @mock_client = mock("twitter_client")
      @mock_client.should_receive(:get_request_token).with(callback).and_return(request_token)
    end
        
    it "should redirect to Twitter authentication page" do
      setup_client
      controller.twitter_client = @mock_client
      get :auth_by_twitter
      response.should be_redirect
    end
    
    it "remember request token and secret by session" do
      setup_client
      controller.twitter_client = @mock_client
      get :auth_by_twitter
      session[:request_token].should_not be_nil
      session[:request_token_secret].should_not be_nil
    end
    
    it "should redirect to group twitter index page when error occured" do
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
  
  describe "requesting 'callback' with GET" do
    before do
      @mock_client = mock("twitter_client")
    end
    
    it "require oauth verifier" do
      get :callback
      response.status.should eql("401 Unauthorized")
    end
    
    it "create a new account with oauth token and verifier" do
      @mock_client.should_receive(:get_access_token).and_return(setup_mock_access_token)
      controller.twitter_client = @mock_client
      lambda do
        get :callback, :oauth_token => "oauth_token", :oauth_verifier => "oauth_verifier"
        account = assigns[:group_twitter_account]
        account.should_not be_nil
        account.user_id.should_not be_nil
        account.screen_name.should_not be_nil
        account.access_token.should_not be_nil
        account.access_token_secret.should_not be_nil
        account.name.should be_nil
        account.profile_image_url.should be_nil
        response.should redirect_to(admin_group_twitter_path)
        flash[:notice].should_not be_nil
      end.should change(GroupTwitterAccount, :count).by(1)
    end
    
    it "find an exist account" do
      lambda do
        @mock_client.should_receive(:get_access_token).and_return(setup_mock_access_token)
        controller.twitter_client = @mock_client
        get :callback, :oauth_token => "oauth_token", :oauth_verifier => "oauth_verifier"
        created = assigns[:group_twitter_account]
        
        @mock_client.should_receive(:get_access_token).and_return(setup_mock_access_token)
        controller.twitter_client = @mock_client
        get :callback, :oauth_token => "oauth_token", :oauth_verifier => "oauth_verifier"
        exist = assigns[:group_twitter_account]
        
        exist.should eql(created)
      end.should change(GroupTwitterAccount, :count).by(1)
    end
    
    it "should redirect to group twitter index page when error occured" do
      @mock_client.should_receive(:get_access_token).and_raise("Error")
      controller.twitter_client = @mock_client
      get :callback, :oauth_token => "oauth_token", :oauth_verifier => "oauth_verifier"
      response.should be_redirect
      response.should redirect_to(admin_group_twitter_url)
      flash[:error].should_not be_nil
    end
  end
end