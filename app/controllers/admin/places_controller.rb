module Admin
  class PlacesController < BaseController
    load_and_authorize_resource

    def index
      @places = Place.paginate(page: params[:page], per_page: 10)
    end

    def edit; end

    def update
      @place.update(place_params)
      respond_with(@place)
    end

    private

    def place_params
      attributes = [
        :id,
        :address,
        :title,
        :latitude,
        :longitude,
      ]
      params.require(:place).permit(*attributes)
    end
  end
end
