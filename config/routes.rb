ActionController::Routing::Routes.draw do |map|
  map.connect 'admin/tweets', :controller => 'admin/tweets'
end