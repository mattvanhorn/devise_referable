ActionController::Routing::Routes.draw do |map|
  map.root :controller => :home
  map.devise_for :users
end
