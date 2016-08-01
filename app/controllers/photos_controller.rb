class PhotosController < ApplicationController
  def index
    @tag = APP_CONFIG.community.instagram_hashtag
    @photos = InstagramService.photos(@tag).take(15)
  end
end
