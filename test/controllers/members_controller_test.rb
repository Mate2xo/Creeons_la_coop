require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  test "route de base members/index accessible" do
    get members_index_url
    assert_response :success
  end

  test "route de base members/show accessible" do
    get members_show_url
    assert_response :success
  end

  test "route de base members/edit accessible" do
    get members_edit_url
    assert_response :redirect
  end

end
