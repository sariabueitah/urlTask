class Api::V1::ShortUrlsController < ApplicationController
  protect_from_forgery with: :null_session
  rate_limit to: 10, within: 3.minutes, only: :encode, with: -> { render_too_many_requests }

  def encode
    short_url = ShortUrl.new(encode_params)

    if short_url.save
      render json: {
        success: true,
        data: {
          original_url: short_url.original_url,
          code: short_url.code
        }
      }, status: :created
    else
      render json: {
        success: false,
        errors: short_url.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def decode
    short_url = ShortUrl.find_by(code: decode_params[:code])
    if short_url
    render json: {
        success: true,
        data: {
          original_url: short_url.original_url,
          code: short_url.code
        }
      }
    else
      render json: {
        success: false,
        error: "Short URL not found"
      }, status: :not_found
    end
  end

  private
  def decode_params
    params.permit(:code)
  end
  def encode_params
    params.permit(:original_url)
  end

  def render_too_many_requests
    render json: {
      success: false,
      error: "Too many requests. Please try again later."
    }, status: :too_many_requests
  end
end
