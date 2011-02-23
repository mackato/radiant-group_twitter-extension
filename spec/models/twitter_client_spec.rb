require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TwitterClient do
  describe "#get_request_token" do
    before do
      @callback_url = "http://example.com/callback"
      @client = TwitterClient.new
    end
    
    it "return request_token" do
      @client.consumer = setup_mock_consumer(@callback_url, mock("request_token"))
      request_token = @client.get_request_token(@callback_url)
    end
    
    it "request_token has token, secret and authorize_url" do
      @client.consumer = setup_mock_consumer(@callback_url)
      request_token = @client.get_request_token(@callback_url)
      request_token.token.should_not be_nil
      request_token.secret.should_not be_nil
      request_token.authorize_url.should_not be_nil
    end
  end
  
  describe "#get_access_token" do
    before do
      @client = TwitterClient.new
    end
    
    it "return access_token" do
      oauth_token = "oauth_token"
      oauth_verifier = "oauth_verifier"
      request_token = mock("request_token")
      access_token = setup_mock_access_token
      request_token.should_receive("get_access_token").
          with({}, :oauth_token => oauth_token, :oauth_verifier => oauth_verifier).
          and_return(access_token)
      @client.request_token = request_token
      
      access_token = @client.get_access_token("request_token", "request_token_secret",
          oauth_token, oauth_verifier)
      access_token.token.should_not be_nil
      access_token.secret.should_not be_nil
      params = access_token.params
      params[:user_id].should_not be_nil
      params[:screen_name].should_not be_nil
    end
  end
end