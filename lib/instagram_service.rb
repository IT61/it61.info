# frozen_string_literal: true
require "nokogiri"
require "json"

class InstagramService
  OPENING_WITH_HTML = "<script type=\"text/javascript\">window._sharedData = "
  CLOSING_WITH_HTML = ";</script>"

  def self.instance
    @__instance__ ||= new
  end

  def self.photos(tag)
    instance.load_photos(tag)
  end

  def load_photos(_tag)
    photos ||= InstagramCache.get(_tag)
    if photos.blank?
      photos = load_from_instagram(_tag)
      InstagramCache.store(_tag, photos) unless photos.blank?
    end
    # return empty array if no photos anywhere
    photos || []
  end

  private

  def raw_url(tag)
    "https://www.instagram.com/explore/tags/#{tag}/"
  end

  def load_from_instagram(_tag)
    url = raw_url _tag
    begin
      page = Nokogiri::HTML open(url)
    rescue
      return nil
    end
    response = find_script_tag_with_content page
    json = JSON.parse (cleanup_response response)
    get_nodes(json).map { |p| p.slice("code", "thumbnail_src") }
  end

  def cleanup_response(response)
    response.to_s.sub(OPENING_WITH_HTML, "").sub(CLOSING_WITH_HTML, "")
  end

  def find_script_tag_with_content(page)
    tags = page.css("script")
    tags.each do |tag|
      return tag if tag.to_s.start_with?(OPENING_WITH_HTML)
    end
  end

  def get_nodes(json)
    json["entry_data"]["TagPage"][0]["tag"]["media"]["nodes"]
  end
end
