ActionController::Routing::Routes.draw do |map|
  #map.connect 'admin/tweets', :controller => 'admin/tweets'
  map.namespace(:admin) do |admin|
    admin.resources :tweets
    admin.resources :twitters
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.connect ':controller/:action'
end
