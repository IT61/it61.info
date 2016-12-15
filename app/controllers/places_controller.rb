class PlacesController < ApplicationController
  respond_to :json

  def index
    @places = Place.all
    respond_with(@places)
  end

  def find
    @places = Place.where("title like :title", title: "%#{params[:title]}%").limit(5)
    render json: @places.map { |place| to_yandex_geoobject place }
  end

  private

  def to_yandex_geoobject(place)
    {
      addressLine: place.address,
      coordinates: [place.latitude, place.longitude],
      place_title: place.title,
      id: place.id,
    }
  end
end
