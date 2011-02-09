ActionController::Routing::Routes.draw do |map|
  #map.connect 'admin/tweets', :controller => 'admin/tweets'
  map.namespace(:admin) do |admin|
    admin.resources :tweets
  end
end
