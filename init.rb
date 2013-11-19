# -*- encoding : utf-8 -*-
require 'redmine'
require_dependency 'dateTools'
require_dependency 'list_user'

Redmine::Plugin.register :redmine_workloadholiday do
  name 'Redmine workloadholiday plugin'
  author 'c0ki'
  description 'This is a plugin for Redmine, originally developed by Rafael Calleja, then Jost Baron. ' +
              'It displays the estimated number of hours users have to work to finish all their ' +
              'assigned issus on time. The holidays can be consider form a side project.'
  version '2.0.0'
  url 'https://github.com/c0ki/redmine_workloadholiday'
  author_url ''

  menu :top_menu, :WorkLoadHoliday, { :controller => 'work_load_holiday', :action => 'show' }, :caption => :workload_title,
    :if =>  Proc.new { User.current.logged? }

  settings :partial => 'settings/workloadholiday_settings',
           :default => {
              "general_workday_monday"    => 'checked',
              "general_workday_tuesday"   => 'checked',
              'general_workday_wednesday' => 'checked',
              'general_workday_thursday'  => 'checked',
              'general_workday_friday'    => 'checked',
              'general_workday_saturday'  => '',
              'general_workday_sunday'    => '',
              'threshold_lowload_min'     => 0.1,
              'threshold_normalload_min'  => 7,
              'threshold_highload_min'    => 8.5
           }

  permission :view_project_workload, :work_load_holiday => :show

end

class RedmineToolbarHookListener < Redmine::Hook::ViewListener
   def view_layouts_base_html_head(context)
		 javascript_include_tag('slides', :plugin => :redmine_workloadholiday ) +
     stylesheet_link_tag('style', :plugin => :redmine_workloadholiday )
   end
end
