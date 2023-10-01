# frozen_string_literal: true

module SchedulesHelper
  def schedule_run_label(schedule)
    return 'Runs daily at' if schedule.daily?
    return 'Runs weekly at' if schedule.weekly?

    'Runs monthly at'
  end

  def schedule_run_text(schedule)
    return schedule.time.to_s if schedule.daily?
    return "#{schedule.time} on #{schedule.day.capitalize}" if schedule.weekly?
    return "#{schedule.time} on the #{schedule.day_of_the_month.ordinalize}" if schedule.monthly?

    "#{schedule.time} on the #{schedule.bi_monthly_day_one.ordinalize} and #{schedule.bi_monthly_day_two.ordinalize}"
  end
end
