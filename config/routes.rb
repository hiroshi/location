ActionController::Routing::Routes.draw do |map|
  map.root :controller => "application"
  map.complete_city "complete_city", :controller => "application", :action => "complete_city"
end
