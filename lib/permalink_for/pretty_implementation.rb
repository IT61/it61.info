module PermalinkFor
  module PrettyImplementation
    extend ActiveSupport::Concern

    def to_param
      return id if new_record?
      target_field_value = send(permalink_configuration[:target_field])
      arr = [I18n.transliterate(target_field_value).parameterize, id]
      arr.delete("")
      arr.join("-")
    end

    module ClassMethods
      def id_from_permalink(link)
        if link.is_a?(Integer) || link[/^\d+$/]
          link.to_i
        else
          link.split("-").last.to_i if link.is_a? String
        end
      end

      def find(id)
        super id_from_permalink(id)
      end
    end
  end
end
