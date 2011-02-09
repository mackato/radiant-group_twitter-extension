# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class GroupTwitterExtension < Radiant::Extension
  version "1.0"
  description "Describe of Group Twitter"
  url "https://github.com/airs/radiant-group_twitter-extension"
  
  # extension_config do |config|
  #   config.gem 'some-awesome-gem
  #   config.after_initialize do
  #     run_something
  #   end
  # end

  # See your config/routes.rb file in this extension to define custom routes
  
  def activate
    admin.tabs.add t("Tweets"), "/admin/tweets", :after => "Pages", :visibility => [:all]
  end
end
