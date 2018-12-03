require 'test_helper'

class ProductorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get productors_index_url
    assert_response :success
  end

  test "should get show" do
    get productors_show_url
    assert_response :success
  end

  test "should get edit" do
    get productors_edit_url
    assert_response :success
  end

end
