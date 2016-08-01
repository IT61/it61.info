class PhotosController < ApplicationController
  def index
    @tag = Settings.community.instagram_hashtag
    @photos = InstagramService.photos(@tag).take(15)
  end
end
