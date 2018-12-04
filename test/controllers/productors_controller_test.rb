require 'test_helper'

class ProductorsControllerTest < ActionDispatch::IntegrationTest
  test "route de base productors/index accessible" do
    get productors_index_url
    assert_response :success
  end

  test "route de base productors/show accessible" do
    get productors_show_url
    assert_response :success
  end

  test "route de base productors/edit accessible" do
    get productors_edit_url
    assert_response :success
  end

end
