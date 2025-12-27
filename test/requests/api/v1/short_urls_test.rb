require "test_helper"

class Api::V1::ShortUrlsTest < ActionDispatch::IntegrationTest
  test "encode creates a short url" do
    post "/api/v1/encode", params: { original_url: "https://example.com" }
    assert_response :created

    json = JSON.parse(response.body)
    assert json["success"]
    assert json["data"]["code"].present?
    assert_equal "https://example.com", json["data"]["original_url"]
  end

  test "decode returns original url" do
    short_url = ShortUrl.create!(original_url: "https://example.com")
    post "/api/v1/decode", params: { code: short_url.code }
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal "https://example.com", json["data"]["original_url"]
  end

  test "decode returns 404 for missing code" do
    post "/api/v1/decode", params: { code: "doesnotexist" }
    assert_response :not_found
  end

  test "decode returns 400 when code missing" do
    post "/api/v1/decode", params: {}
    assert_response :bad_request
  end
end
