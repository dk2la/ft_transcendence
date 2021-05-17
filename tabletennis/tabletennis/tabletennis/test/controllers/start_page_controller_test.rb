require "test_helper"

class StartPageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get start_page_index_url
    assert_response :success
  end
end
