# -*- encoding : utf-8 -*-
if Rails::VERSION::MAJOR < 3
  ActionController::Routing::Routes.draw do |map|
    map.connect 'work_load_holiday/:action/:id', :controller => :work_load_holiday
  end
else
  match 'work_load_holiday/(:action(/:id))', :controller => 'work_load_holiday'
end
