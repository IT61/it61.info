module Admin
  class PlacesController < BaseController
    load_and_authorize_resource

    def index
      @places = Place.paginate(page: params[:page], per_page: 10)
    end

    def edit; end

    def update
      commit = @place.update place_params
      if commit
        redirect_to admin_places_path, notice: "Данные места обновлены"
      else
        flash.now[:error] = "Не получилось обновить место"
        render :edit
      end
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

    def set_place
      @place = Place.find(place_params[:id])
    end
  end
end
