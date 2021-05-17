require "test_helper"

class ListPlayersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get list_players_index_url
    assert_response :success
  end

  test "should get show" do
    get list_players_show_url
    assert_response :success
  end
end
