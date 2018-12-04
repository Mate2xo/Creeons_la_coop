require 'test_helper'

class InfosControllerTest < ActionDispatch::IntegrationTest
  test "page infos/index accessible" do
    get infos_index_url
    assert_response :success
  end

  test "page infos/show accessible" do
    get infos_show_url
    assert_response :success
  end

  test "page infos/edit accessible" do
    get infos_edit_url
    assert_response :success
  end

end
