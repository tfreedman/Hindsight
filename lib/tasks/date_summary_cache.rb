    require 'action_view'
    ActiveRecord::Base.logger = nil
    include ActionView::Helpers::DateHelper

    started_at = Time.now
    puts "Started at: #{started_at}"

    event_types = [
      'AdiumMessage',
      'AndroidCall',
      'AndroidMms',
      'AndroidSms',
      'BikeshareTrip',
      'CalendarEvent',
      'CalendarHoliday',
      'CalendarOngoing',
      'ColloquyMessage',
      'DiscordMessage',
      'EmailMessage',
      'FacebookMessage',
      'FinancialTransaction',
      'FitbitMeasurement',
      'ForumPost',
      'GitHubCommit',
      'GoogleChatMessage',
      'GoogleTalkMessage',
      'HangoutsEvent',
      'HindsightFileDOC',
      'HindsightFilePSD',
      'HindsightFileAI',
      'LoungeLog',
      'MamircEvent',
      'MatrixEvent',
      'MircLog',
      'N3dsActivityEvent',
      'Photo',
      'PhotoAlbum',
      'PidginMessage',
      'PrestoTrip',
      'SkypeMessage',
      'VoipmsSms',
      'WiiPlaytime',
      'WindowsPhoneSms',
      'XchatLog'
    ] 

    DateSummary.delete_all # Clear the cache

    event_types.each do |event_type|
      dates = Hash.new { |hash, key| hash[key] = 0 }

      if event_type == 'AdiumMessage'
        AdiumMessage.where.not(enabled: false).find_each do |e|
          event_date = Time.at(e.timestamp).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'AndroidCall'
        AndroidCall.find_each do |e|
          event_date = Time.at(e.date / 1000).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'AndroidMms'
        AndroidMms.find_each do |e|
          event_date = Time.at(e.date / 1000).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'AndroidSms'
        AndroidSms.find_each do |e|
          event_date = Time.at(e.date / 1000).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "BikeshareTrip"
        BikeshareTrip.find_each do |e|
          # Start of ride
          event_date = Time.at(e.start_time).to_date.to_s
          dates[event_date] += 1
  
          # End of ride
          event_date = Time.at(e.end_time).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'CalendarEvent' # Normal calendar events
        CalendarEvent.where.not('calendar ILIKE ?', "%holiday%").where.not('calendar ILIKE ?', "%ALBUMS%").where.not('calendar ILIKE ?', "%Ongoing%").find_each do |e|
          time = Time.at(e.start_time).end_of_day
          while time <= Time.at(e.end_time).end_of_day
            event_date = time.to_date.to_s
            dates[event_date] += 1
            time += 1.day
          end
        end
      elsif event_type == 'CalendarOngoing' # Long-term things to treat separately
        CalendarEvent.where('calendar ILIKE ?', "%Ongoing%").find_each do |e|
          time = Time.at(e.start_time).end_of_day
          while time <= Time.at(e.end_time).end_of_day
            event_date = time.to_date.to_s
            dates[event_date] += 1
            time += 1.day
          end
        end
      elsif event_type == 'CalendarHoliday' # Typical holidays
        CalendarEvent.where('calendar ILIKE ?', "%holiday%").find_each do |e|
          time = Time.at(e.start_time).end_of_day
          while time <= Time.at(e.end_time).end_of_day
            event_date = time.to_date.to_s
            dates[event_date] += 1
            time += 1.day
          end
        end
      elsif event_type == 'ColloquyMessage'
        ColloquyMessage.where(enabled: true).find_each do |e|
          event_date = Time.at(e.timestamp).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'DiscordMessage'
        DiscordMessage.find_each do |e|
          event_date = Time.at(e.timestamp).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "EmailMessage"
        EmailMessage.find_each do |e|
          event_date = Time.at(e.timestamp).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'FacebookMessage'
        FacebookMessage.find_each do |e|
          event_date = Time.at(e.timestamp / 1000).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'FinancialTransaction'
        FinancialTransaction.find_each do |e|
          dates[e.date] += 1
        end
      elsif event_type == "FitbitMeasurement"
        FitbitMeasurement.find_each do |e|
          event_date = Time.at(e.log_id).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "ForumPost"
        ForumPost.find_each do |e|
          event_date = Time.at(e.timestamp).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'GitHubCommit'
        GitHubCommit.find_each do |e|
          event_date = Time.at(e.timestamp).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'GoogleChatMessage'
        GoogleChatMessage.where(enabled: true).find_each do |e|
          event_date = Time.at(e.created_date).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'GoogleTalkMessage'
        GoogleTalkMessage.where(enabled: true).find_each do |e|
          event_date = e.timestamp.to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'HangoutsEvent'
        HangoutsEvent.where(enabled: true).find_each do |e|
          event_date = Time.at(e.timestamp / 1000000).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'HindsightFileDOC'
        HindsightFile.where(extension: ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx']).find_each do |e|
          event_date = e.created_at.to_date.to_s
          dates[event_date] += 1
        end
        HindsightFile.where(extension: ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx']).find_each do |e|
          event_date = e.modified_at.to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'HindsightFilePSD'
        HindsightFile.where(extension: 'psd').find_each do |e|
          event_date = e.created_at.to_date.to_s
          dates[event_date] += 1
        end
        HindsightFile.where(extension: 'psd').find_each do |e|
          event_date = e.modified_at.to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'HindsightFileAI'
        HindsightFile.where(extension: 'ai').find_each do |e|
          event_date = e.created_at.to_date.to_s
          dates[event_date] += 1
        end
        HindsightFile.where(extension: 'ai').find_each do |e|
          event_date = e.modified_at.to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "LoungeLog"
        LoungeLog.where.not(room: nil).where(enabled: true).find_each do |e|
          event_date = e.timestamp.to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "MamircEvent"
        MamircEvent.where.not(room: nil).where(enabled: true).find_each do |e|
          event_date = Time.at(e.timestamp / 1000).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "MatrixEvent"
        MatrixEvent.find_each do |e|
          next if e.sender.start_with?('@facebook_')
          event_date = Time.at(e.origin_server_ts / 1000).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "MircLog"
        MircLog.find_each do |e|
          event_date = e.timestamp.to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'N3dsActivityEvent'
        N3dsActivityEvent.find_each do |e|
          dates[e.date] += 1
        end
      elsif event_type == "Photo"
        Photo.find_each do |e|
          event_date = Time.at(e.timestamp).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "PhotoAlbum"
        PhotoAlbum.find_each do |e|
          time = Time.at(e.start_time).end_of_day
          while time <= Time.at(e.end_time).end_of_day
            event_date = time.to_date.to_s
            dates[event_date] += 1
            time += 1.day
          end
        end
      elsif event_type == 'PidginMessage'
        PidginMessage.where(enabled: true).find_each do |e|
          event_date = Time.at(e.timestamp).to_date.to_s
          dates[event_date] += 1 
        end
      elsif event_type == "PrestoTrip"
        PrestoTrip.find_each do |e|
          event_date = Time.at(e.timestamp.to_i).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "SkypeMessage"
        SkypeMessage.find_each do |e|
          event_date = Time.at(e.timestamp.to_i).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "VoipmsSms"
        VoipmsSms.find_each do |e|
          event_date = Time.at(e.date).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'WiiPlaytime'
        WiiPlaytime.find_each do |e|
          dates[e.date] += 1
        end
      elsif event_type == "WindowsPhoneSms"
        WindowsPhoneSms.find_each do |e|
          event_date = Time.at(e.timestamp).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "XchatLog"
        XchatLog.where(enabled: true).find_each do |e|
          event_date = e.timestamp.to_date.to_s
          dates[event_date] += 1
        end  
      end
    
      dates.each do |key, value|
        ds = DateSummary.where(date: key, event_type: event_type).first
        if ds.nil?
          DateSummary.create(date: key, event_type: event_type, count: value)
        end
      end
    end

    ended_at = Time.now
    puts "Ended at #{ended_at}"
    puts "DateSummary cache took #{distance_of_time_in_words(ended_at, started_at)} to build"
