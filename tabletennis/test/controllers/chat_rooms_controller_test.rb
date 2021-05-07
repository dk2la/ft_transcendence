require "test_helper"

class ChatRoomsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chat_rooms_index_url
    assert_response :success
  end

  test "should get show" do
    get chat_rooms_show_url
    assert_response :success
  end

  test "should get new" do
    get chat_rooms_new_url
    assert_response :success
  end

  test "should get create" do
    get chat_rooms_create_url
    assert_response :success
  end

  test "should get update" do
    get chat_rooms_update_url
    assert_response :success
  end
end
