class PlacesController < ApplicationController

  def index
    render json: Place.all
  end

  def find
    @places = Place.where("title like :title", title: "%#{params[:title]}%").limit(5)
    render json: @places.map { |place| to_yandex_geoobject place }
  end

  private

  def to_yandex_geoobject(place)
    {
        meta: place.address,
        coordinates: [place.latitude, place.longitude],
        place_title: place.title,
    }
  end
end
