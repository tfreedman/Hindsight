class Location < ActiveRecord::Base
  def formatted_name
    return self[:name] + ', ' + self[:country_code]
  end
end
