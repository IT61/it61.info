# frozen_string_literal: true
module PermalinkFor::SlugImplementation
  extend ActiveSupport::Concern

  module ClassMethods
    def permalink_validation_opts
      return super if defined?(super)
      {
        presence: true,
        uniqueness: true,
        format: { with: /\A[a-z0-9_-]+\Z/ },
      }
    end
  end

  included do
    validates :permalink, permalink_validation_opts
    before_validation :build_permalink
  end

  def to_param
    return permalink if permalink.present?
    id
  end

  def build_permalink
    target_field_value = send(permalink_configuration[:target_field])

    return if permalink.present? || target_field_value.blank?
    permalink_base = I18n.transliterate(target_field_value).parameterize.downcase
    permalink_candidate = permalink_base
    generated_permalink = nil

    attempts_number = 100
    attempts = attempts_number
    while attempts > 0 && generated_permalink.nil?
      if self.class.find_by(permalink: permalink_candidate)
        attempts -= 1
        permalink_candidate = permalink_base + (attempts_number - attempts).to_s
      else
        generated_permalink = permalink_candidate
      end
    end

    fail "Failed to generate permalink" if generated_permalink.nil?
    self.permalink = generated_permalink
  end

  module ClassMethods
    def find(id)
      if id.is_a?(Array) || id.is_a?(Fixnum) || (id.is_a?(String) && id[/^\d+$/])
        super
      else
        find_by!(permalink: id.to_s.downcase)
      end
    end
  end
end
