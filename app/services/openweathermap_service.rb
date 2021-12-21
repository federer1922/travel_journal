module OpenweathermapService
  def self.call(city)
    key = ENV['WEATHER_API_KEY']

    openweather_response = HTTP.get("https://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{key}&units=metric")
    success = openweather_response.status == 200
    if success
      openweather_response_json = openweather_response.body.to_s
      openweather_result = MultiJson.load(openweather_response_json)

      main_temp = openweather_result["main"]["temp"]
      wind_speed = openweather_result["wind"]["speed"]
      clouds_all = openweather_result["clouds"]["all"]

      { success: true, temperature: main_temp, wind: wind_speed, clouds: clouds_all }
    else
      openweather_response_json = openweather_response.body.to_s
      openweather_result = MultiJson.load(openweather_response_json)

      cod = openweather_result["cod"]
      message = openweather_result["message"]

      { success: false, http_status: cod, alert: message }
    end
  end
end