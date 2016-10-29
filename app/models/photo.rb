class Photo
  def self.from_instagram
    tag = Settings.community.instagram_hashtag
    InstagramService.photos(tag).take(15)
  end
end
