### Workload-Plugin for Redmine

A fork of the original workload-plugin from Rafael Calleja then rewrite by Jost Baron. The
plugin calculates how much work each user would have to do per day in order
to hit the deadlines for all his issues.

To be able to do this calculation, the issues start date, due date and
estimated time must be filled in. Issues that have not filled in one of
these fields will be shown in the overview, but the workload resulting from
these issues will be ignored.

#### Installation

The plugin is tested with redmine 2.3.2.

To install it, simply clone it into the plugins-directory. Execute

    git clone https://github.com/c0ki/redmine_workloadholiday.git redmine_workloadholiday

in your plugins directory. Then restart your redmine. There is no need for
database migration, as this plugin does not change anything in the database.

#### Configuration

There are two places where this plugin might be configured:

1. In the plugin settings, available in the administration area under "plugins".
2. In the Roles-section of the administration area, the plugin adds a new
  permission "view workload data in own projects". When this permission is given
  to a user in a project, he might see the workload of all the members of that
  project.

#### Permissions

The plugin shows the workload as follows:

* An anonymous user can't see any workload.
* An admin user can see the workload of everyone.
* Any normal user can see the following workload:

  - He may always see his own workload.
  - He may see the workload of every user that is member of a project for which
    he has the permission "view workload data in own projects" (see above).
  - When showing the issues that contribute to the workload, only issues visible
    to the current user are shown. Invisible issues are only summarized.

#### Licence

Attribution 3.0 Unported: http://creativecommons.org/licenses/by/3.0/deed

You are free:
* to Share — to copy, distribute and transmit the work
* to Remix — to adapt the work
* to make commercial use of the work


Under the following conditions:
* Attribution — You must attribute the work in the manner specified by the author or licensor 
  (but not in any way that suggests that they endorse you or your use of the work). 

#### ToDo

* Add legend (again).
* Use nicer colors for workload indications.
