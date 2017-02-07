class Material < ApplicationRecord
  include ActiveModel::Validations
  validates_with UrlValidator

  validates :url, presence: true

  belongs_to :postrelease
end
