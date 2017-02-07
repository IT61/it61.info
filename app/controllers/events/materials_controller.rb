module Events
  class MaterialsController < ApplicationController
    def create
      @postrelease = Postrelease.find(params[:postrelease_id])

      material = @postrelease.materials.create(material_params)
      unless material.persisted?
        flash[:error] = t("flashes.empty_link_field")
      end
        redirect_to edit_event_postrelease_path(event_id: @postrelease.event, id: @postrelease.id)
    end

    def edit; end

    def update; end

    def destroy
      @material = Material.find(params[:id])
      @material.destroy
      redirect_to edit_event_postrelease_path(event_id: params[:event_id], id: @material.postrelease.id)
    end

    private

    def material_params
      params.require(:materials).permit(:url)
    end
  end
end
