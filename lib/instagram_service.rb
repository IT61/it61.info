require "nokogiri"
require "json"


class InstagramService
  OPENING_WITH_HTML = "<script type=\"text/javascript\">window._sharedData = "
  CLOSING_WITH_HTML = ";</script>"

  def self.instance
    @__instance__ ||= new
  end

  def self.photos(tag)
    instance.get_photos(tag)
  end

  def get_photos(tag)
    url = raw_url(tag)
    page = Nokogiri::HTML(open(url))
    content = find_script_tag_with_content(page)
    parse_data(content.to_s)
  end

  private

  def find_script_tag_with_content(page)
    tags = page.css("script")
    tags.each do |tag|
      return tag if tag.to_s.start_with?(OPENING_WITH_HTML)
    end
  end

  def parse_data(content)
    json = JSON.parse content.sub(OPENING_WITH_HTML, "").sub(CLOSING_WITH_HTML, "")
    # what a terrible hardcode...
    json["entry_data"]["TagPage"][0]["tag"]["media"]["nodes"]
  end

  def raw_url(tag)
    "https://www.instagram.com/explore/tags/#{tag}/"
  end

end