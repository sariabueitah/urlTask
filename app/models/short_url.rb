class ShortUrl < ApplicationRecord
  require "net/http"
  require "uri"
  # TODO: length as 7 is enough i think maybe change it later
  CODE_LENGTH = 7
  before_validation :generate_code, on: :create
  before_validation :fix_url, on: :create

  validates :original_url, presence: true
  validates :code, presence: true, uniqueness: true, length: { is: CODE_LENGTH }, if: -> { original_url.present? }
  validate :check_url, if: -> { original_url.present? }

  # check if url starts with http or https add if missing and parse the url to make sure the formate is valid
  def fix_url
    return if original_url.blank?

    unless original_url.match?(/\Ahttp(s)?:\/\//)
      self.original_url = "https://#{original_url}"
    end

    parsed = URI.parse(original_url)

    unless parsed.is_a?(URI::HTTP) && parsed.host.present?
      errors.add(:original_url, "not a valid http or https link")
      return
    end

    self.original_url = parsed.to_s
  rescue URI::InvalidURIError
      errors.add(:original_url, "not a valid http or https link")
  end

  # make a request to the url and check if its a real used url
  def check_url
    return if original_url.blank?

    parsed = URI.parse(original_url)

    http = Net::HTTP.new(parsed.host, parsed.port)
    http.use_ssl = (parsed.scheme == "https")
    http.open_timeout = 3
    http.read_timeout = 6

    response = http.request_head(parsed.request_uri)

    unless response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPRedirection)
      errors.add(:original_url, "no site with this url #{response.code}")
    end
  rescue StandardError => e
    errors.add(:original_url, "no site with this url #{e.message}")
  end

  def generate_code
    return if original_url.blank? || code.present?
    # while loop that breaks when the generated code is not a duplicate
    loop do
      self.code = SecureRandom.alphanumeric(CODE_LENGTH)
      break unless ShortUrl.exists?(code: code)
    end
  end
end
