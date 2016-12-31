class PhotosController < ApplicationController
  def index
    @photos = Photo.from_instagram
    @tag = Settings.community.instagram_hashtag
  end
end
