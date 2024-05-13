require 'uri'
require 'net/http'

class Forecast
  def initialize(zipcode)
    @zipcode = zipcode
    get_forecast
  end
  
  def zipcode(zipcode)
    @zipcode = zipcode
    get_forecast
  end
  
  def zipcode
    @zipcode
  end
  
  def get_noaa_forecast
    #
    # Here is a sample REST URL for NOAA's National Weather Service Forecast
    #
    #    https://digital.mdl.nws.noaa.gov/xml/sample_products/browser_interface/ndfdBrowserClientByDay.php?zipCodeList=20910+25414&format=24+hourly&numDays=7
    #
    # This web service was found at https://digital.mdl.nws.noaa.gov/xml/rest.php on 5/12/2024
    # See "Summerized Data for One or More Zipcodes" section
    #
    restUrl = URI("https://digital.mdl.nws.noaa.gov/xml/sample_products/browser_interface/ndfdBrowserClientByDay.php?XMLformat=DWML&format=24+hourly&numDays=7&zipCodeList=" + @zipcode)
    begin
      http = Net::HTTP.new(restUrl.host, restUrl.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(restUrl)
      response = http.request(request)
      body = response.read_body
      weatherHash = JSON.parse(body)
    rescue => e
      # TODO: deal with errors
      #
      # specifically validly formatted number strings that are not actually zip codes (or don't have weather data)
      #
      nil
    end
  end
  
  def get_forecast
    if @zipcode
      forecast_hash = Rails.cache.fetch("Matt's Weather Forecast Cache") do
        {}
      end
      if forecast_hash[@zipcode] && (forecast_hash[@zipcode]["updated_at"] > (DateTime.now - 30.minutes))
        forecast_hash[@zipcode]["from_cache?"] = true
        forecast_hash[@zipcode]
      else
        forecast_hash[@zipcode] = {}
        forecast_hash[@zipcode]["forecast"] = get_noaa_forecast
        forecast_hash[@zipcode]["from_cache?"] = false
      end
      nil # no zipcode set...return nil
    end
  end

end