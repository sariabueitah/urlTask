require "test_helper"

class ShortUrlControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get short_url_new_url
    assert_response :success
  end

  test "should get create" do
    get short_url_create_url
    assert_response :success
  end

  test "should get index" do
    get short_url_index_url
    assert_response :success
  end
end
