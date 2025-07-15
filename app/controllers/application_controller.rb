class ApplicationController < ActionController::Base
  before_action :check_session_keys, except: [:auth]

  include UserFilters

  # This variable exists so SocialLink's ERB files can be loaded straight into Hindsight
  SOCIALLINK_BASE_MEDIA_URL = "https://#{Hindsight::Application.credentials.sociallink_url}"

  def auth
    if params[:key] == Hindsight::Application.credentials.auth_token
      #session[:key] = "hello!"
      render plain: ":)" and return
    end
    render plain: ":(" and return
  end
  
  def check_session_keys
    if !session[:key] || (session[:key] && session[:key] != "hello!")
      render :json => {:status=>false}, :status => 401 and return
    end
  end

  def overview
    @pagename = 'overview' 
    @title = 'Overview'
    if params[:year]
      @date = Date.new(params[:year].to_i, 01, 01)
    else
      @date = Date.new(Time.now.year, 01, 01)
    end
    @types = DateSummary.pluck(:event_type).uniq.sort
    summaries = DateSummary.where(:date => @date..(@date + 1.year - 1.day)).all

    @totals = Hash.new { |hash, key| hash[key] = 0 }
    @events = Hash.new
    summaries.each do |summary|
      @events[summary.date] = {} if @events[summary.date].nil?
      @events[summary.date][summary.event_type] = summary.count
      @totals[summary.event_type] += summary.count
    end
  end

  def date    
    @date = Date.parse("#{params[:yyyy]}-#{params[:mm]}-#{params[:dd]}")
    if params[:start_date].nil?
      params[:start_date] = "#{params[:yyyy]}-#{params[:mm]}-#{params[:dd]}"
    end
    @pagename = 'date'
    @title = @date.to_s + ' - Hindsight'

    @events = []
    @hours = {}
    @weather = {}

    (@date.beginning_of_day.to_i .. @date.end_of_day.to_i).step(1.hour) do |date|
      #@events << {sort_time: Time.at(date).to_i, type: 'hour', content: Time.at(date)}
      @hours[Time.at(date).to_i] = []
    end

    weather = HistoricalWeatherReading.where(:timestamp => (@date.beginning_of_day.to_i * 1000)..(@date.end_of_day.to_i * 1000)).all
    weather.each do |reading|
      if @weather[reading.location].nil?
        @weather[reading.location] = {}
      end
      @weather[reading.location][(reading[:timestamp] / 1000).to_i] = reading
    end

    bikeshare_trips = BikeshareTrip.where('start_time <= ? AND end_time >= ?', @date.end_of_day.to_i, @date.beginning_of_day.to_i).all
    bikeshare_trips.each do |trip|
      @events << {sort_time: trip.start_time, type: 'bikeshare_trip', content: trip}
    end

    photo_albums = PhotoAlbum.where('start_time <= ? AND end_time >= ?', @date.end_of_day.to_i, @date.beginning_of_day.to_i).where(enabled: true).all
    photo_albums.each do |album|
      # Create a second event representing the end time of a photo album
      if album.end_time >= @date.end_of_day.to_i
        end_time = @date.end_of_day.to_i
      else
        end_time = album.end_time
      end

      # Hide events that ran yesterday and end at 12:00:00
      next if album.start_time <= @date.beginning_of_day.to_i && album.end_time == @date.beginning_of_day.to_i

      next if album.start_time <= @date.beginning_of_day.to_i && album.end_time >= @date.end_of_day.to_i
      @events << {sort_time: album.start_time, type: 'Photo Albums', content: album, group: 'photo_album_' + album.id.to_s}
      @events << {sort_time: end_time, type: 'Photo Albums', content: album, group: 'photo_album_' + album.id.to_s}
    end

    android_calls = AndroidCall.where(:date => (@date.beginning_of_day.to_i * 1000)..(@date.end_of_day.to_i * 1000)).all
    android_calls.each do |call|
      @events << {sort_time: call.date / 1000, type: 'android_call', content: call}
    end

    hindsight_files = HindsightFile.where(:created_at => @date.beginning_of_day..@date.end_of_day).all
    hindsight_files += HindsightFile.where(:modified_at => @date.beginning_of_day..@date.end_of_day).all

    hindsight_files.uniq.each do |file|
      @events << {sort_time: file.created_at.to_i, type: 'hindsight_file', content: file, kind: 'created'}
      @events << {sort_time: file.modified_at.to_i, type: 'hindsight_file', content: file, kind: 'last modified'}
    end

    photos = Photo.where(:timestamp => @date.beginning_of_day.to_i..@date.end_of_day.to_i).all
    photos.each do |photo|
      begin
        next if photo.is_sidecar?
        next if photo.lightroom_rating == 1.0
  
        phototags = photo.lightroom_phototags.collect{ |name| 
          snpc = ServiceNamePathCache.where(name: name).first
          if snpc && Hindsight::Application.credentials.sociallink_integration
            "<a href=\"https://#{Hindsight::Application.credentials.sociallink_url}/profiles/#{snpc.uid}\">#{name}</a>"
          else
            name
          end
        }.to_sentence
        @events << {sort_time: photo.timestamp, type: 'Photos', content: photo, caption: phototags}
      rescue
        logger.info photo.id
      end
    end

    windows_phone_sms = WindowsPhoneSms.where(:timestamp => @date.beginning_of_day.to_i..@date.end_of_day.to_i).all
    windows_phone_sms.each do |sms|
      @events << {sort_time: sms.timestamp, type: 'windows_phone_sms_' + (sms.real_name || '(Unknown)'), content: sms}
    end

    android_sms = AndroidSms.where(:date => (@date.beginning_of_day.to_i * 1000)..(@date.end_of_day.to_i * 1000)).all
    android_sms.each do |sms|
      @events << {sort_time: sms.date / 1000, type: 'android_sms_' + (sms.contact_name || '(Unknown)'), content: sms}
    end

    android_mms = AndroidMms.where(:date => (@date.beginning_of_day.to_i * 1000)..(@date.end_of_day.to_i * 1000)).where(enabled: true).all
    android_mms.each do |mms|
      @events << {sort_time: mms.date / 1000, type: 'android_mms_' + (mms.contact_name || '(Unknown)'), content: mms}
    end

    voipms_sms = VoipmsSms.where(:date => (@date.beginning_of_day)..(@date.end_of_day)).where(enabled: true).all
    voipms_sms.each do |sms|
      @events << {sort_time: sms.date.to_i, type: 'voipms_sms_' + (sms.contact || '(Unknown)'), content: sms}
    end

    lounge_logs = LoungeLog.where(:timestamp => (@date.beginning_of_day)..(@date.end_of_day), enabled: true).all
    lounge_logs.each do |message|
      @events << {sort_time: message.timestamp.to_i, type: 'lounge_log_' + message.room, content: message}
    end

    adium_messages = AdiumMessage.where(:timestamp => (@date.beginning_of_day)..(@date.end_of_day), enabled: true).all
    adium_messages.each do |message|
      @events << {sort_time: message.timestamp.to_i, type: 'adium_message_' + message.receiver, content: message}
    end

    pidgin_messages = PidginMessage.where(:timestamp => (@date.beginning_of_day)..(@date.end_of_day), enabled: true).all
    pidgin_messages.each do |message|
      if message.real_receiver && message.real_sender
        sender = ([message.real_sender, message.real_receiver] - [Hindsight::Application.credentials.real_name]).sort[0].to_s
      else
        sender = message.receiver
      end
      @events << {sort_time: message.timestamp.to_i, type: 'pidgin_message_' + sender, content: message}
    end

    email_messages = EmailMessage.where(:timestamp => (@date.beginning_of_day)..(@date.end_of_day)).all
    email_messages.each do |message|
      @events << {sort_time: message.timestamp.to_i, type: 'email_message_' + message.account, content: message}
    end

    calendar_events = CalendarEvent.where('start_time <= ? AND end_time >= ?', @date.end_of_day.to_i, @date.beginning_of_day.to_i).all
    calendar_events.each do |event|
      next if event.summary.start_with?('ALBUM:') # We cover this by reading the photo album table directly
      next if event.end_time >= (@date.end_of_day.to_i + 1) && event.start_time <= @date.beginning_of_day.to_i

      # Hide events that ran yesterday and end at 12:00:00
      next if event.start_time <= @date.beginning_of_day.to_i && event.end_time == @date.beginning_of_day.to_i

      @events << {sort_time: event.start_time, type: 'calendar_event_' + event.calendar, content: event, end_time: event.end_time, group: 'calendar_event_' + event.id.to_s}

      # Ignore events that are exactly 1 minute long
      next if event.end_time == (event.start_time + 60)

      # Create a second calendar event representing the end time of an event
      if event.end_time >= @date.end_of_day.to_i
        end_time = @date.end_of_day.to_i
      else
        end_time = event.end_time
      end
      @events << {sort_time: end_time, type: 'calendar_event_' + event.calendar, content: event, end_time: event.end_time, group: 'calendar_event_' + event.id.to_s}
    end

    hangouts_events = HangoutsEvent.where(:timestamp => (@date.beginning_of_day.to_i * 1000000)..(@date.end_of_day.to_i * 1000000), enabled: true).all
    hangouts_events.each do |h|
      type = 'hangouts_event_' + h.conversation_id
      result = filter_events(h, type)
      if result
        @events << {sort_time: (result.timestamp / 1000000).to_i, type: type, content: result}
      end
    end

    microsoft_teams_messages = MicrosoftTeamsMessage.where(:original_arrival_time => @date.beginning_of_day..@date.end_of_day).all
    microsoft_teams_messages.each do |message|
      @events << {sort_time: message.original_arrival_time.to_i, content: message, type: 'microsoft_teams_message_' + message.conversation.display_name.to_s}
    end

    facebook_messages = FacebookMessage.where(:timestamp => (@date.beginning_of_day.to_i * 1000)..(@date.end_of_day.to_i * 1000)).all
    facebook_messages.each do |message|
      @events << {sort_time: (message.timestamp / 1000).to_i, content: message, type: 'facebook_message_' + message.room.title}
    end

    google_chat_messages = GoogleChatMessage.where(enabled: true).where(:created_date => (@date.beginning_of_day)..(@date.end_of_day)).all
    google_chat_messages.each do |g|
      @events << {sort_time: g.created_date, content: g, type: 'google_chat_message_' + g.room}
    end

    google_talk_messages = GoogleTalkMessage.where(enabled: true).where(:timestamp => (@date.beginning_of_day)..(@date.end_of_day)).all
    google_talk_messages.each do |g|
      @events << {sort_time: g.timestamp.to_i, content: g, type: 'google_talk_message_' + g.room}
    end

    xchat_logs = XchatLog.where(enabled: true).where(:timestamp => (@date.beginning_of_day)..(@date.end_of_day)).all
    xchat_logs.each do |log|
      @events << {sort_time: log.timestamp.to_i, content: log, type: 'xchat_log_' + log.room}
    end

    colloquy_messages = ColloquyMessage.where(:timestamp => @date.beginning_of_day.to_i..@date.end_of_day.to_i).where(enabled: true).all
    colloquy_messages.each do |message|
      @events << {sort_time: message.timestamp.to_i, content: message, type: 'colloquy_message_' + message.room}
    end

    mamirc_events = MamircEvent.where(:timestamp => (@date.beginning_of_day.to_i * 1000)..(@date.end_of_day.to_i * 1000)).where(enabled: true).all
    mamirc_events.each do |message|
      @events << {sort_time: message.timestamp.to_i, content: message, type: 'mamirc_event_' + message.room}
    end

    mirc_logs = MircLog.where(:timestamp => (@date.beginning_of_day)..(@date.end_of_day)).all
    mirc_logs.each do |message|
      @events << {sort_time: message.timestamp.to_i, content: message, type: 'mirc_log_' + message.room}
    end

    matrix_events = MatrixEvent.where(:origin_server_ts => ((@date.beginning_of_day.to_i - 600) * 1000)..((@date.end_of_day.to_i + 600) * 1000)).all

    # Only allow bridged facebook events that are newer than the last Facebook data download
    fm = FacebookMessage.order(timestamp: :desc).first
    if fm
      last_facebook_message_timestamp = fm.timestamp
    else
      last_facebook_message_timestamp = 0
    end

    matrix_events.each do |event|
      type = 'matrix_event_' + event.room_id
      result = filter_events(event, type, {last_facebook_message_timestamp: last_facebook_message_timestamp})

      if result && @date.beginning_of_day.to_i <= event.timestamp && @date.end_of_day.to_i >= event.timestamp
        @events << {sort_time: event.timestamp, type: type, content: result}
      end
    end

    presto_trips = PrestoTrip.where(:timestamp => @date.beginning_of_day.to_i..@date.end_of_day.to_i).all
    presto_trips.each do |trip|
      @events << {sort_time: trip.timestamp.to_i, type: 'presto_trip', content: trip}
    end

    discord_messages = DiscordMessage.where(:timestamp => @date.beginning_of_day..@date.end_of_day).all
    discord_messages.each do |message|
      @events << {sort_time: message.timestamp.to_i, type: 'discord_message_' + message.discord_channel_id, content: message}
    end

    skype_messages = SkypeMessage.where(:timestamp => @date.beginning_of_day.to_i..@date.end_of_day.to_i).where(enabled: true).all
    skype_messages.each do |message|
      @events << {sort_time: message.timestamp, type: 'skype_message_' + message.room_name, content: message}
    end

    fitbit_measurements = FitbitMeasurement.where(:log_id => @date.beginning_of_day.to_i..@date.end_of_day.to_i).all
    fitbit_measurements.each do |f|
      @events << {sort_time: f.log_id, type: 'Fitbit', content: f}
    end

    forum_posts = ForumPost.where(:timestamp => @date.beginning_of_day.to_i..@date.end_of_day.to_i).all
    forum_posts.each do |f|
      @events << {sort_time: f.timestamp, type: 'forum_post', content: f}
    end

    github_commits = GitHubCommit.where(timestamp: @date.beginning_of_day.to_i..@date.end_of_day.to_i).all
    github_commits.each do |g|
      @events << {sort_time: g.timestamp, type: 'github_commit', content: g}
    end

    if Hindsight::Application.credentials.sociallink_integration
      youtube_videos = YoutubeVideo.where(published_at: @date.beginning_of_day..@date.end_of_day).all
      youtube_videos.each do |y|
        @events << {sort_time: y.published_at.to_i, type: 'sociallink', sub_type: 'youtube_video', content: y}
      end

      deviantart_posts = DeviantartPost.where(pubdate: @date.beginning_of_day..@date.end_of_day).all
      deviantart_posts.each do |d|
        @events << {sort_time: d.pubdate.to_i, type: 'sociallink', sub_type: 'deviantart_post', content: d}
      end

      pixiv_posts = PixivPost.where(created_at: @date.beginning_of_day..@date.end_of_day).all
      pixiv_posts.each do |p|
        @events << {sort_time: p.created_at.to_i, type: 'sociallink', sub_type: 'pixiv_post', content: p}
      end

      tumblr_posts = TumblrPost.where(timestamp: @date.beginning_of_day..@date.end_of_day).all
      tumblr_posts.each do |t|
        @events << {sort_time: t.timestamp.to_i, type: 'sociallink', sub_type: 'tumblr_post', content: t}
      end

      facebook_posts = FBID.where(timestamp: @date.beginning_of_day.to_i..@date.end_of_day.to_i).all
      facebook_posts.each do |f|
        @events << {sort_time: f.timestamp, type: 'sociallink', sub_type: 'facebook_post', content: f}
      end

      webcomic_strips = Webcomic.where(date: @date).all
      webcomic_strips.each do |w|
        @events << {sort_time: w.date.beginning_of_day.to_i, type: 'sociallink', sub_type: 'webcomic_strip', content: w}
      end

      instagram_stories = InstagramStory.where(timestamp: @date.beginning_of_day.to_i..@date.end_of_day.to_i).all
      instagram_stories.each do |i|
        @events << {sort_time: i.timestamp, type: 'sociallink', sub_type: 'instagram_story', content: i}
      end

      instagram_posts = InstagramPost.where(timestamp: @date.beginning_of_day.to_i..@date.end_of_day.to_i).all
      instagram_posts.each do |i|
        @events << {sort_time: i.timestamp, type: 'sociallink', sub_type: 'instagram_post', content: i}
      end

      twitter_accounts = TwitterAccount.pluck(:user_id)
      twitter_tweets = TwitterTweet.where(time: @date.beginning_of_day..@date.end_of_day, user_id: twitter_accounts).all
      twitter_tweets.each do |t|
        @events << {sort_time: t.time.to_i, type: 'sociallink', sub_type: 'twitter_tweet', content: t}
      end

      mastodon_accounts = MastodonAccount.pluck(:user_id)
      mastodon_toots = MastodonToot.where(user_id: mastodon_accounts, created_at: @date.beginning_of_day..@date.end_of_day).order('created_at DESC').all
      mastodon_toots.each do |m|
        @events << {sort_time: m.created_at.to_i, type: 'sociallink', sub_type: 'mastodon_toot', content: m}
      end

      bluesky_accounts = BlueskyAccount.pluck(:did)
      bluesky_posts = BlueskyPost.where(user_did: bluesky_accounts, sort_at: @date.beginning_of_day..@date.end_of_day).order('sort_at DESC').all
      bluesky_posts.each do |b|
        @events << {sort_time: b.sort_at.to_i, type: 'sociallink', sub_type: 'bluesky_post', content: b}
      end
    end

    @on_this_day = {}
    financial_transactions = FinancialTransaction.where(:date => @date).all
    financial_transactions.each do |f|
      @on_this_day[:financial_transactions] = [] if @on_this_day[:financial_transactions].nil?
      @on_this_day[:financial_transactions] << {type: 'financial_transaction', content: f}
    end

    @ongoing_events = OngoingEvent.where('start_date <= ? AND end_date >= ?', @date, @date).all

    N3dsActivityEvent.where(date: @date).find_each do |n|
      @on_this_day[:nintendo_3ds_activity_event] = [] if @on_this_day[:nintendo_3ds_activity_event].nil?
      @on_this_day[:nintendo_3ds_activity_event] << {type: 'nintendo_3ds_activity_event', content: n}
    end

    WiiPlaytime.where(date: @date).find_each do |n|
      @on_this_day[:wii_playtime] = [] if @on_this_day[:wii_playtime].nil?
      @on_this_day[:wii_playtime] << {type: 'wii_playtime', content: n}
    end

    magazines = []
    if !Hindsight::Application.credentials.magazines_path.blank?
      Dir.foreach(Hindsight::Application.credentials.magazines_path) do |magazine|
        next if magazine == '.' or magazine == '..' or !File.directory?(Hindsight::Application.credentials.magazines_path)
        Dir.foreach(Hindsight::Application.credentials.magazines_path + magazine) do |issue|
          next if issue == '.' or issue == '..' or issue == '.DS_Store'
          if issue.start_with? @date.strftime("%Y-%m ")
            magazines << {name: issue.split(@date.strftime("%Y-%m "))[1].split('.')[0], url: "https://#{Hindsight::Application.credentials.development_hosts[0]}/magazines/#{magazine}/#{issue}"}
          end
        end
      end
    end

    magazines.each do |magazine|
      @on_this_day[:magazines] = [] if @on_this_day[:magazines].nil?
      @on_this_day[:magazines] << magazine
    end

    calendar_events.each do |event|
      next if event.summary.start_with?('ALBUM:') # We cover this by reading the photo album table directly
      if event.end_time >= (@date.end_of_day.to_i + 1) && event.start_time <= @date.beginning_of_day.to_i
        @on_this_day[:all_day_events] = [] if @on_this_day[:all_day_events].nil?
        @on_this_day[:all_day_events] << {sort_time: event.start_time, type: 'calendar_event_' + event.calendar, content: event, end_time: event.end_time}
      end
    end

    photo_albums.each do |album|
      @on_this_day[:all_day_events] = [] if @on_this_day[:all_day_events].nil?
      if album.start_time <= @date.beginning_of_day.to_i && album.end_time >= @date.end_of_day.to_i || (album.deep_parsed == false)
        @on_this_day[:all_day_events] << {sort_time: album.start_time, type: 'Photo Albums', content: album}
      end
    end

    @events = @events.sort_by{ |event|
      event[:sort_time]
    }

    @event_types = {}
    @events.each do |event|
      if event[:sort_time] < @date.beginning_of_day.to_i
        event[:sort_time] = @date.beginning_of_day.to_i
      end

      if event[:end_time] && event[:end_time] > @date.end_of_day.to_i
        event[:end_time] = @date.end_of_day.to_i
      end

      top = ((event[:sort_time] - @date.beginning_of_day.to_i) * 180) / 1000
      if top > 0
        event[:top] = top
      else
        event[:top] = 0
      end

      if event[:end_time].nil?
        event[:height] = 1
      elsif ((event[:end_time] - event[:sort_time]) / 1000) > 15552
        event[:height] = 15552
      else
        event[:height] = (event[:end_time] - event[:sort_time]) - event[:top]
      end

      if @hours[Time.at(event[:sort_time]).beginning_of_hour.to_i]
        @hours[Time.at(event[:sort_time]).beginning_of_hour.to_i] << event
      end
    end

    # Group events into columns
    @event_groups = {}
    @events.pluck(:type).each do |type|
      @event_groups[type] = 0 if @event_groups[type].nil?
      @event_groups[type] += 1
    end

    @event_groups = @event_groups.sort_by{ |k, v|
      [-v, k]
    }.to_h

    @event_groups.each_with_index do |(k, v), i|
      @event_groups[k] = i
    end
  
    #Side Menu
    @event_types = @events.pluck(:type).uniq.sort!
    @event_type_headings = {}
    @event_types.each do |type|
      if type.start_with?('matrix_event_')
        @event_type_headings['Matrix Rooms:'] = [] if @event_type_headings['Matrix Rooms:'].nil?
        @event_type_headings['Matrix Rooms:'] << type
      elsif type.start_with?('hangouts_event')
        @event_type_headings['Hangouts Rooms:'] = [] if @event_type_headings['Hangouts Rooms:'].nil?
        @event_type_headings['Hangouts Rooms:'] << type
      else
        @event_type_headings['Other:'] = [] if @event_type_headings['Other:'].nil?
        @event_type_headings['Other:'] << type
      end
    end
  end

  def photos
    if params[:id] 
      photo = Photo.where(id: params[:id]).first
      if photo
        path = photo.path
        path = photo.lightroom_export if photo.lightroom_export
        file_extension = path.split('/')[-1].split('.')[-1].upcase
        if ['JPG', 'JPEG'].include?(file_extension)
          if params[:format] == 'thumbnail'
            image = `exiftool -b -ThumbnailImage #{Shellwords.escape(path)}`
            if !image.empty? # Built-in thumbnail
              send_data image, type: 'image/jpeg', disposition: 'inline'
            else # No built-in thumbnails
              if !File.file?("#{Rails.root.to_s}/photocache/#{photo.id}-thumb.jpg")
                `convert -thumbnail 400 #{Shellwords.escape(path)} #{Rails.root.to_s}/photocache/#{photo.id}-thumb.jpg`
              end
              send_file "#{Rails.root.to_s}/photocache/#{photo.id}-thumb.jpg", disposition: 'inline'
            end
          elsif ['orig', 'preview'].include?(params[:format])
            send_file path, disposition: 'inline'
          end
          ':('
        elsif ['TIF', 'TIFF'].include?(file_extension) # TIFF files can't be rendered inline
          rotate_deg = 0
          if photo.lightroom_image
            orientation = photo.lightroom_image.orientation
            if orientation == 'AB'
              # do nothing
            elsif orientation == 'BC'
              rotate_deg = 90
            elsif orientation == 'CD'
              rotate_deg = 180
            elsif orientation == 'DA'
              rotate_deg = 270
            end
          end
          if !File.file?("#{Rails.root.to_s}/photocache/#{photo.id}-0.jpg")
            `convert -rotate #{rotate_deg} #{Shellwords.escape(path)} #{Rails.root.to_s}/photocache/#{photo.id}.jpg`
          end
          if params[:format] == 'thumbnail'
            send_file "#{Rails.root.to_s}/photocache/#{photo.id}-1.jpg", disposition: 'inline'
          else
            send_file "#{Rails.root.to_s}/photocache/#{photo.id}-0.jpg", disposition: 'inline'
          end
        elsif ['PNG'].include?(file_extension) # PNGs generally don't have thumbnails
          send_file path, disposition: 'inline'
        elsif ['CR2'].include?(file_extension)
          if params[:format] == 'thumbnail'
            image = `exiftool -b -ThumbnailImage #{Shellwords.escape(path)}`
          elsif params[:format] == 'preview'
            image = `exiftool -b -PreviewImage #{Shellwords.escape(path)}`
          end
          send_data image, type: 'image/jpeg',  disposition: 'inline' if image
          ':('
        elsif ['DNG'].include?(file_extension)
          if ['preview', 'thumbnail'].include?(params[:format])
            image = `exiftool -b -s -PreviewImage #{Shellwords.escape(path)}`
            send_data image, type: 'image/jpeg',  disposition: 'inline'
          end
          ':('
        else
          ':('
        end
      else
        ':('
      end
    else
      ':('
    end
  end

  def todo
  end
end
