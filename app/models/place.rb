class Place < ApplicationRecord
  has_many :events

  validates_presence_of :title, :address

  def full_address
    [address, title].join(", ")
  end

  def self.first_or_create_place(place_params)
    where(
      title: place_params[:title],
      address: place_params[:address],
      latitude: place_params[:latitude],
      longitude: place_params[:longitude]
    ).first_or_create(place_params)
  end
end
