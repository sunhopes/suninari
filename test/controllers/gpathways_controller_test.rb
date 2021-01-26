require 'test_helper'

class GpathwaysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gpathways_index_url
    assert_response :success
  end

  test "should get show" do
    get gpathways_show_url
    assert_response :success
  end

  test "should get new" do
    get gpathways_new_url
    assert_response :success
  end

  test "should get edit" do
    get gpathways_edit_url
    assert_response :success
  end

end
