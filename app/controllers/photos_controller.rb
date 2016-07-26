# frozen_string_literal: true
class PhotosController < ApplicationController
  def index
    @tag = "it61"
    @photos = InstagramService.photos(@tag).take(15)
  end
end
