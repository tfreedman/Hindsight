class HistoricalWeatherReading < ActiveRecord::Base
  serialize :info

  establish_connection :hindsight

  def description
    return (self[:weathertype].to_s + ' ' + self[:conditions].to_s).downcase
  end

  def feels_like
    begin
      if self[:heat_index]
        return '%.1f' % self[:heat_index]
      elsif self[:windchill]
        return '%.1f' % self[:windchill]
      else
        return '%.1f' % self[:temp]
      end
    rescue
      return '???'
    end
  end
end
