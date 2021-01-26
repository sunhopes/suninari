require 'test_helper'

class GpathwayControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get gpathway_top_url
    assert_response :success
  end

end
