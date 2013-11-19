# -*- encoding : utf-8 -*-
class DateTools

  # Returns a list of all regular working weekdays.
  # 1 is monday, 7 is sunday (same as in Date::cwday)
  def self.getWorkingDays()
    result = Set::new

    result.add(1) if Setting['plugin_redmine_workloadholiday']['general_workday_monday'] != ''
    result.add(2) if Setting['plugin_redmine_workloadholiday']['general_workday_tuesday'] != ''
    result.add(3) if Setting['plugin_redmine_workloadholiday']['general_workday_wednesday'] != ''
    result.add(4) if Setting['plugin_redmine_workloadholiday']['general_workday_thursday'] != ''
    result.add(5) if Setting['plugin_redmine_workloadholiday']['general_workday_friday'] != ''
    result.add(6) if Setting['plugin_redmine_workloadholiday']['general_workday_saturday'] != ''
    result.add(7) if Setting['plugin_redmine_workloadholiday']['general_workday_sunday'] != ''

    return result
  end

  @@getWorkingDaysInTimespanCache = {}

  def self.getWorkingDaysInTimespan(timeSpan, user, noCache = false)
    raise ArgumentError unless timeSpan.kind_of?(Range)
    raise ArgumentError unless user.kind_of?(User)

    return @@getWorkingDaysInTimespanCache[timeSpan][user] unless @@getWorkingDaysInTimespanCache[timeSpan].nil? ||
        @@getWorkingDaysInTimespanCache[timeSpan][user].nil? || noCache

    workingDays = self::getWorkingDays()

    working_days_in_timespan = Set::new

    timeSpan.each do |day|
      if workingDays.include?(day.cwday) then
        working_days_in_timespan.add(day)
      end
    end

    issue = Issue.arel_table
    project = Project.arel_table

    # Fetch all issues that on holidays project
    issues = Issue.joins(:project).
        joins(:status).
        joins(:assigned_to).
        where(issue[:assigned_to_id].eq(user.id)).# Are assigned to the interesting user
        where(project[:id].eq(Setting['plugin_redmine_workloadholiday']['holidays_project'])).# Are on the interesting project
        where(issue[:status_id].eq(11)) # Is valid

    result = working_days_in_timespan
    working_days_in_timespan.each do |day|
      issues.each do |issue|
        if (day >= issue.start_date && day <= issue.due_date)
          result.delete(day)
        end
      end
    end

    @@getWorkingDaysInTimespanCache[timeSpan] = {} if @@getWorkingDaysInTimespanCache[timeSpan].nil?
    @@getWorkingDaysInTimespanCache[timeSpan][user] = result

    return result
  end

  def self.getWorkingDaysForUsersInTimespan(timeSpan, users, noCache = false)
    raise ArgumentError unless timeSpan.kind_of?(Range)
    raise ArgumentError unless users.kind_of?(Array)

    result = {}

    users.each do |user|
      result[user] = getWorkingDaysInTimespan(timeSpan, user, noCache)
    end

    return result
  end

  @@getHolydayDaysInTimespanCache = {}

  def self.getHolydayDaysInTimespan(timeSpan, user, noCache = false)
    raise ArgumentError unless timeSpan.kind_of?(Range)
    raise ArgumentError unless user.kind_of?(User)

    return @@getHolydayDaysInTimespanCache[timeSpan][user] unless @@getHolydayDaysInTimespanCache[timeSpan].nil? ||
        @@getHolydayDaysInTimespanCache[timeSpan][user].nil? || noCache

    issue = Issue.arel_table
    project = Project.arel_table

    # Fetch all issues that on holidays project
    issues = Issue.joins(:project).
        joins(:status).
        joins(:assigned_to).
        where(issue[:assigned_to_id].eq(user.id)).# Are assigned to the interesting user
        where(project[:id].eq(Setting['plugin_redmine_workloadholiday']['holidays_project'])).# Are on the interesting project
        where(issue[:status_id].eq(11)) # Is valid

    result = Set::new
    timeSpan.each do |day|
      issues.each do |issue|
        if (day >= issue.start_date && day <= issue.due_date)
          result.add(day)
        end
      end
    end

    @@getHolydayDaysInTimespanCache[timeSpan] = {} if @@getHolydayDaysInTimespanCache[timeSpan].nil?
    @@getHolydayDaysInTimespanCache[timeSpan][user] = result

    return result

  end

  def self.getHolydayDaysForUsersInTimespan(timeSpan, users, noCache = false)
    raise ArgumentError unless timeSpan.kind_of?(Range)
    raise ArgumentError unless users.kind_of?(Array)

    result = {}

    users.each do |user|
      result[user] = getHolydayDaysInTimespan(timeSpan, user, noCache)
    end

    return result
  end

  def self.getRealDistanceInDays(timeSpan, user)
    raise ArgumentError unless timeSpan.kind_of?(Range)
    raise ArgumentError unless user.kind_of?(User)

    return self::getWorkingDaysInTimespan(timeSpan, user).size
  end
end
