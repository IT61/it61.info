module Events
  class PostreleasesController < ApplicationController
    load_and_authorize_resource

    def new
      @postrelease = Event.find(params[:event_id]).postrelease
      if @postrelease.nil?
        @postrelease = Postrelease.new
      else
        flash[:error] = t("flashes.postrelease_already_created")
        redirect_to event_path(@postrelease.event)
      end
    end

    def create
      @postrelease = Event.find(params[:event_id]).postrelease
      if @postrelease.nil?
        @postrelease = Postrelease.create(postrelease_params) do |p|
          p.event = Event.find(params[:event_id])
        end
        if @postrelease.errors.empty?
          redirect_to event_path(@postrelease.event)
        else
          render :new
        end
      else
        flash[:error] = t("flashes.postrelease_already_created")
        redirect_to event_path(@postrelease.event)
      end
    end

    def edit
      # edit
    end

    def update
      @postrelease = Postrelease.find(params[:id])

      success = @postrelease.update(postrelease_params)

      if success
        redirect_to event_path(@postrelease.event)
      else
        render "edit"
      end
    end

    def publish
      @postrelease = Postrelease.find(params[:id])
      if @postrelease&.body.present? || @postrelease&.materials.present?
        @postrelease.publish!
        flash[:success] = t("flashes.postrelease_published")
      else
        flash[:error] = t("flashes.empty_postrelease_publicate")
      end
      redirect_to event_path(@postrelease.event)
    end

    def unpublish
      @postrelease = Postrelease.find(params[:id])
      @postrelease.unpublish!
      flash[:success] = t("flashes.postrelease_unpublished")
      redirect_to event_path(@postrelease.event)
    end

    private

    def postrelease_params
      permitted_attrs = [
        :body,
        :public,
        materials_attributes: [
          :id,
          :url,
          :raw_info,
          :postrelease_id,
          :_destroy,
        ],
      ]
      params.require(:postrelease).permit(*permitted_attrs)
    end
  end
end
