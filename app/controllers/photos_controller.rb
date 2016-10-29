class PhotosController < ApplicationController
  def index
    @photos = Photo.from_instagram
  end
end
