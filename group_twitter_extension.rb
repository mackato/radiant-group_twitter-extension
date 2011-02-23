# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'
require File.join(File.expand_path(File.dirname(__FILE__)), 'config', 'environments', RAILS_ENV)

class GroupTwitterExtension < Radiant::Extension
  version "1.0"
  description "Describe of Group Twitter"
  url "https://github.com/airs/radiant-group_twitter-extension"

  # See your config/routes.rb file in this extension to define custom routes
  include GroupTwitterEnvironment

  def activate
    Radiant::Config['CONSUMER_KEY'] = CONSUMER_KEY
    Radiant::Config['CONSUMER_SECRET'] = CONSUMER_SECRET
    
    tab 'Content' do
      add_item "Tweets", "/admin/tweets", :after => "Pages", :visibility => [:all]
    end
    
    tab 'Settings' do
      add_item "Group Twitter", "/admin/group_twitter", :after => "Users", :visibility => [:admin]
    end
  end
end
