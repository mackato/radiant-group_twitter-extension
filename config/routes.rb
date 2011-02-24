ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.tweets 'tweets/:action/:id', :controller => 'tweets'
    admin.group_twitter 'group_twitter/:action/:id', :controller => 'group_twitter'
  end
end
