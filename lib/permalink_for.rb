module PermalinkFor
  extend ActiveSupport::Concern

  PERMALINK_TYPES = {
    slug: SlugImplementation,
    pretty: PrettyImplementation
  }.freeze

  class_methods do
    def permalink_for(field, as: :pretty)
      as = as.to_sym
      unless PERMALINK_TYPES.key? as
        raise "Unknown permalink type :#{as} (may be :slug or :pretty)"
      end
      include PERMALINK_TYPES[as]

      config = { target_field: field }
      cattr_reader :permalink_configuration
      class_variable_set(:@@permalink_configuration, config)
    end
  end
end

ActiveRecord::Base.send(:include, PermalinkFor)
