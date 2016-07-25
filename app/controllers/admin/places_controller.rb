class Admin::PlacesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_place, only: [:edit, :update]

  def index
    @places = Place.paginate page: params[:page], per_page: 10
  end

  def edit
  end

  def update
    commit = @place.update place_params
    if commit
      redirect_to admin_places_path, notice: 'Данные места обновлены'
    else
      flash.now[:error] = 'Не получилось обновить место'
      render 'edit'
    end
  end

  private

  def place_params
    params.require(:place).permit :address, :title, :latitude, :longitude
  end

  def set_place
    @place = Place.find params[:id]
  end

end
