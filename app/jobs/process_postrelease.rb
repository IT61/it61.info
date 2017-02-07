class ProcessPostrelease < ActiveJob::Base
  queue_as :default

  require "net/http"

  def perform(postrelease_id)
    materials = Material.where(postrelease_id: postrelease_id, processed: false)
    materials.each do |material|
      begin
        url = URI.parse(embed_url(material.url))
        material.processed = true
      rescue
        "Not vailid URI"
        material.processed = false
      end
      response = Net::HTTP.get(url)
      unless response.blank?
        material.raw_info = JSON.parse(response)
      end
      material.save!
    end
  end

  private

  def embed_url(url)
    if url.include?("slideshare.net")
      slideshare url
    elsif url.include?("youtube.com")
      youtube url
    elsif url.include?("youtu.be")
      youtube url
    else
      ""
    end
  end

  def slideshare(slideshare_url)
    "https://www.slideshare.net/api/oembed/2?url=#{slideshare_url}&format=json"
  end

  def youtube(yt_url)
    "https://www.youtube.com/oembed?url=#{yt_url}&format=json"
  end
end
