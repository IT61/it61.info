module PermalinkFor::PrettyImplementation
  extend ActiveSupport::Concern

  def to_param
    return id if new_record?
    target_field_value = send(permalink_configuration[:target_field])
    arr = [I18n.transliterate(target_field_value).parameterize, id]
    arr.delete('')
    arr.join('-')
  end

  module ClassMethods
    def find(id)
      id = id.split('-').last.to_i if id.is_a? String
      super id
    end
  end
end
