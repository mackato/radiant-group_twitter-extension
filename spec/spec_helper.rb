unless defined? RADIANT_ROOT
  ENV["RAILS_ENV"] = "test"
  case
  when ENV["RADIANT_ENV_FILE"]
    require ENV["RADIANT_ENV_FILE"]
  when File.dirname(__FILE__) =~ %r{vendor/radiant/vendor/extensions}
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../../../")}/config/environment"
  else
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/environment"
  end
end
require "#{RADIANT_ROOT}/spec/spec_helper"

Dataset::Resolver.default << (File.dirname(__FILE__) + "/datasets")

if File.directory?(File.dirname(__FILE__) + "/matchers")
  Dir[File.dirname(__FILE__) + "/matchers/*.rb"].each {|file| require file }
end

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  # config.use_instantiated_fixtures  = false
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures'

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
end

def setup_mock_request_token(params = {})
  token = params[:token] || "request_token_token"
  secret = params[:secret] || "request_token_secret"
  authorize_url = "http://twitter.com/oauth/authorize?oauth_token=#{token}"
  mock = mock("request_token")
  mock.should_receive(:token).and_return(token)
  mock.should_receive(:secret).and_return(secret)
  mock.should_receive(:authorize_url).and_return(authorize_url)
  mock
end

def setup_mock_consumer(callback, request_token = nil)
  request_token ||= setup_mock_request_token
  mock = mock("consumer")
  mock.should_receive(:get_request_token).
    with({ :oauth_callback => callback }).and_return(request_token)
  mock
end

def setup_mock_access_token(params = {})
  token = params[:token] || "access_token_token"
  secret = params[:secret] || "access_token_secret"
  mock = mock("access_token")
  mock.should_receive(:token).and_return(token)
  mock.should_receive(:secret).and_return(secret)
  mock.should_receive(:params).and_return(:user_id => 1, :screen_name => "admin")
  mock
end
