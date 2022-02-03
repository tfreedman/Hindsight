class CalendarEvent < ActiveRecord::Base
  def start_date
    return Time.at(self[:start_time]).to_date
  end

  def end_date
    return Time.at(self[:end_time]).to_date
  end

  establish_connection :hindsight
end
