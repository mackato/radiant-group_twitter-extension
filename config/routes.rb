ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.resources :tweets
    admin.group_twitter 'group_twitter/:action', :controller => 'group_twitter'
  end
end
