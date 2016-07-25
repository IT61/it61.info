class Admin::PlacesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @places = Place.paginate page: params[:page], per_page: 10
  end

  def edit
    @place = fetch_place
  end

  def update
    @place = fetch_place
    commit = @place.update place_params
    if commit
      redirect_to '/admin/places', notice: 'Данные места обновлены'
    else
      flash.now[:error] = 'Не получилось обновить место'
      render 'edit'
    end
  end

  private

  def place_params
    params.require(:place).permit :address, :title, :latitude, :longitude
  end

  def fetch_place
    Place.find params[:id]
  end

end
