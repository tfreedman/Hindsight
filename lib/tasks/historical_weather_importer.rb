x = File.read('/path/to/weather.json') ; nil
output = JSON.parse(x) ; nil
ActiveRecord::Base.logger = nil
output['location']['values'].each do |value|
  if HistoricalWeatherReading.where(location: 'New York,NY,US', timestamp: value['datetime']).first.nil?
    HistoricalWeatherReading.create(
      wdir: value["wdir"],
      temp: value["temp"],
      maxt: value["maxt"],
      visibility: value["visibility"],
      wspd: value["wspd"],
      timestamp: value["datetime"],
      solarenergy: value["solarenergy"],
      heatindex: value["heatindex"],
      cloudcover: value["cloudcover"],
      mint: value["mint"],
      precip: value["precip"],
      solarradiation: value["solarradiation"],
      weathertype: value["weathertype"],
      snowdepth: value["snowdepth"],
      sealevelpressure: value["sealevelpressure"],
      snow: value["snow"],
      dew: value["dew"],
      humidity: value["humidity"],
      precipcover: value["precipcover"],
      wgust: value["wgust"],
      conditions: value["conditions"],
      windchill: value["windchill"],
      info: value["info"],
      latitude: output['location']['latitude'],
      longitude: output['location']['longitude'],
      location: output['location']['id']
    )
  end
end
