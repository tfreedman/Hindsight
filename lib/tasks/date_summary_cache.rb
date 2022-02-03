    require 'action_view'
    ActiveRecord::Base.logger = nil
    include ActionView::Helpers::DateHelper

    started_at = Time.now
    puts "Started at: #{started_at}"

    event_types = [
      'AdiumMessage',
      'AndroidSms',
      'BikeshareTrip',
      'CalendarEvent',
      'ColloquyMessage',
      'EmailMessage',
      'FacebookMessage',
      'FinancialTransaction',
      'FitbitMeasurement',
      'GitHubCommit',
      'HangoutsEvent',
      'LoungeLog',
      'MamircEvent',
      'MatrixEvent',
      'MircLog',
      'Photo',
      'PhotoAlbum',
      'PidginMessage',
      'PrestoTrip',
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
      elsif event_type == 'CalendarEvent'
        CalendarEvent.find_each do |e|
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
          event_date = Time.at(e.logId).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'GitHubCommit'
        GitHubCommit.find_each do |e|
          event_date = Time.at(e.timestamp).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == 'HangoutsEvent'
        HangoutsEvent.where(enabled: true).find_each do |e|
          event_date = Time.at(e.timestamp / 1000000).to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "LoungeLog"
        LoungeLog.where.not(room: nil).where(enabled: true).find_each do |e|
          event_date = e.timestamp.to_date.to_s
          dates[event_date] += 1
        end
      elsif event_type == "MamircEvent"
        MamircEvent.where.not(room: nil, enabled: false).find_each do |e|
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
