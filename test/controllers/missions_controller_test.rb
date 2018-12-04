require 'test_helper'

class MissionsControllerTest < ActionDispatch::IntegrationTest
  test "route de base missions/index accessible" do
    get missions_index_url
    assert_response :success
  end

  test "route de base missions/show accessible" do
    get missions_show_url
    assert_response :success
  end

  test "route de base missions/edit accessible" do
    get missions_edit_url
    assert_response :success
  end

end
