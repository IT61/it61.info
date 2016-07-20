# frozen_string_literal: true
class PhotosController < ApplicationController
  def index
    @photos = InstagramService.photos("it61").take(15)
  end
end
