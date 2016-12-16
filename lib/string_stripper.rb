module StringStripper
  module InclusionMethods
    def strip_strings(*args)
      options = args.extract_options!

      cattr_accessor :string_stripper_string_attributes
      self.string_stripper_string_attributes = args

      before_validation :string_stripper_run

      include InstanceMethods
    end
  end

  module InstanceMethods
    def string_stripper_run
      self.string_stripper_string_attributes.each do |field|
        string_stripper_run_on(field)
      end
    end

    def string_stripper_run_on(field)
      self.write_attribute(field, self.read_attribute(field).strip) if self.read_attribute(field).is_a?(String)
    end
  end
end
