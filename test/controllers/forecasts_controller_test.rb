require "test_helper"

class ForecastsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get forecasts_index_url
    assert_response :success
  end

  test "should get show" do
    get "/forecast/98072"
    assert_response :success
  end
  
  test "should return invalid zipcode" do
    get "/forecast/9807"
    assert_redirected_to("/")
    get "/forecast/980723"
    assert_redirected_to("/")
    get "/forecast/9807a"
    assert_redirected_to("/")
    get "/forecast/9807*"
    assert_redirected_to("/")
  end
  
end
