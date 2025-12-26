class ShortUrlsController < ApplicationController
  before_action :set_short_url, only: [ :show ]
  def index
    @short_urls = ShortUrl.all
  end

  def new
    @short_url = ShortUrl.new
  end

  def show
  end

  def create
    @short_url = ShortUrl.new(short_url_params)

    if @short_url.save
      redirect_to @short_url, notice: "created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def redirect
    @short_url = ShortUrl.find_by(code: params[:code])
    if @short_url
      redirect_to @short_url.original_url, allow_other_host: true
    else
      # TODO: change this to not found page
      render plain: "URL not found", status: :not_found
    end
  end

  private

  def set_short_url
    @short_url = ShortUrl.find(params[:id])
  end

  def short_url_params
    params.require(:short_url).permit(:original_url)
  end
end
