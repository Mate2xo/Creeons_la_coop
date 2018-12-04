require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "tout le monde peut accéder à la home" do
    get root_url
    assert_response :success
  end

  test "les visiteurs ne peuvent pas accéder au dashboard des membres, et doivent être redirigés" do
    get static_pages_dashboard_url
    assert_response :redirect
    # follow_redirect!
    # assert_response :success
    # assert_redirected_to new_member_session_path
  end

end
