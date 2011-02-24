require 'rubygems'
require 'oauth'

class TwitterClient
  attr_accessor :consumer, :request_token
  
  def self.consumer
    @@consumer ||= OAuth::Consumer.new(
      Radiant::Config['CONSUMER_KEY'],
      Radiant::Config['CONSUMER_SECRET'],
      :site => 'https://api.twitter.com'
    )
  end
  
  def initialize
    @consumer = TwitterClient.consumer
  end
  
  def get_request_token(callback)
    @consumer.get_request_token({ :oauth_callback => callback })
  end
  
  def get_access_token(request_token, request_token_secret, oauth_token, oauth_verifier)
    @request_token ||= OAuth::RequestToken.new(@consumer, request_token, request_token_secret)
    @request_token.get_access_token({},
      :oauth_token => oauth_token, :oauth_verifier => oauth_verifier)
  end
end