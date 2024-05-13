require 'forecast'

class ForecastsController < ApplicationController
  def index
    @zipcode = nil
    if flash[:errors]
      @errors = flash[:errors] ? flash[:errors] : []
      @zipcode = flash[:errors][0]['value']
    end
  end
  
  def fetch
    @zipcode = params[:zipcode]
    @errors = []
    if is_zip_code(@zipcode)
      forecast = Forecast.new(@zipcode)      
      redirect_to "/forecast/#{@zipcode}"
    else
      @errors << {item: :zipcode, code: :invalid_zipcode, message: "Zipcode is in an invalid format", value: @zipcode}
      p " in error of fetch"
      flash[:errors] = @errors
      redirect_to "/"
    end
  end

  def show
    @zipcode = params[:zipcode]
    @errors = []
    if is_zip_code(@zipcode)
      forecast = Forecast.new(@zipcode)
      @forecast_hash = forecast.get_forecast
    else
      @errors << {item: :zipcode, code: :invalid_zipcode, message: "Zipcode is in an invalid format", value: @zipcode}
      flash[:errors] = @errors
      redirect_to "/"
    end
  end
  
private

  def is_zip_code(zipcode)
    zipcode[/^\d{5}$/]
  end
end
