module ApplicationHelper
  include UserFilters

  def friendly_groups(k)
    if k.include?('matrix_event_')
      room_title = MatrixRoom.where(room_id: k.gsub('matrix_event_', '')).first.name
      if room_title == '' || room_title.nil?
        (MatrixRoom.where(room_id: k.gsub('matrix_event_', '')).first.participants - [Hindsight::Application.credentials.mxid]).to_sentence.truncate(25)
      else
        room_title
      end
    elsif k.start_with?('email_message')
      k.split('email_message_')[1] + ' (email)'
    elsif k.include?('facebook_message_')
      k.gsub('facebook_message_', '')
    elsif k.include?('pidgin_message_')
      k.gsub('pidgin_message_', '')
    elsif k.include?('calendar_event_')
      k.gsub('calendar_event_', '').downcase.capitalize + ' (Calendar)'
    elsif k.include?('adium_message_')
      k.gsub('adium_message_', '')
    elsif k.include?('mirc_log_')
      k.gsub('mirc_log_', '')
    elsif k.include?('hangouts_event_')
      (HangoutsConversation.where(conversation_id: k.gsub('hangouts_event_', '')).first.participant_data.pluck('fallback_name') - [Hindsight::Application.credentials.real_name]).to_sentence
    elsif k.include?('android_sms_')
      k.gsub('android_sms_', '') + ' (SMS)'
    elsif k.include?('windows_phone_sms_')
      k.gsub('windows_phone_sms_', '') + ' (SMS)'
    elsif k.include?('xchat_log_')
      k.gsub('xchat_log_', '') + " (X-Chat)"
    elsif k.include?('github_commit')
      "GitHub Commits"
    elsif k.include?('android_call')
      "Call Log"
    elsif k.include?('youtube_video')
      "YouTube"
    elsif k.include?('deviantart_post')
      "DeviantArt"
    else
      k
    end
  end

  def alternate_time_zones(date)
    return Location.where(date: date).where.not(name: Hindsight::Application.credentials.default_location.split(',')[0]).all
  end

  def colors(type)
    color = override_colors(type)
    return color || 'transparent'
  end

  def colors2(number)
    [
      '#42d2ff',
      '#ff4141',
      '#5be975',
      '#a069eb',
      '#ffb63c',
      '#ffed40',
      '#31abff',
      '#ff762b',
      '#83cc1d',
      '#ff4eff',
      '#ff4141'
    ][number % 11]
  end

  def get_weather_icon(weather)
    sunrise = Sun.sunrise(Time.at(weather.timestamp / 1000), weather.latitude, weather.longitude).to_i
    sunset = Sun.sunset(Time.at(weather.timestamp / 1000), weather.latitude, weather.longitude).to_i
    sunrise = sunrise <= (weather.timestamp / 1000)
    sunset = sunset <= (weather.timestamp / 1000)
    description = weather.description

    if (description.include?('clear'))
      if (sunrise == true && sunset == false)
        return '/images/weather/sun.svg';
      else
        return '/images/weather/moon.svg';
      end
    elsif (description.include?('fog') || description.include?('haze') || description.include?('mist'))
      if (sunrise == true && sunset == false)
        return '/images/weather/cloudFogSunAlt.svg';
      else
        return '/images/weather/cloudFogMoonAlt.svg';
      end
    elsif (description.include?('freezing rain'))
      if (sunrise == true && sunset == false)
        return '/images/weather/cloudHailAltSun.svg';
      else
        return '/images/weather/cloudHailAltMoon.svg';
      end
    elsif (description.include?('clouds') || description.include?('cloudy') || description.include?('overcast'))
      if (sunrise == true && sunset == false)
        return '/images/weather/cloudSun.svg';
      else
        return '/images/weather/cloudMoon.svg';
      end
    elsif (description.include?('snow') || description.include?('sleet'))
      if (sunrise == true && sunset == false)
        return '/images/weather/cloudSnowSunAlt.svg';
      else
        return '/images/weather/cloudSnowMoonAlt.svg';
      end
    elsif (description.include?('thunderstorm'))
      if (sunrise == true && sunset == false)
        return '/images/weather/cloudLightningSun.svg';
      else
        return '/images/weather/cloudLightningMoon.svg';
      end
    elsif (description.include?('drizzle'))
      if (sunrise == true && sunset == false)
        return '/images/weather/cloudDrizzleSun.svg';
      else
        return '/images/weather/cloudDrizzleMoon.svg';
      end
    elsif (description.include?('rain'))
      if (sunrise == true && sunset == false)
        return '/images/weather/cloudRainSun.svg';
      else
        return '/images/weather/cloudRainMoon.svg';
      end
    else
      return '/images/weather/tornado.svg';
    end
  end
end
