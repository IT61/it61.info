require "ostruct"
require "yaml"
require "erb"

all_config = YAML.load_file(Rails.root.join("config", "config.yml"))
APP_CONFIG = JSON.parse(all_config.to_json, object_class: OpenStruct)
ERB::APP_CONFIG = APP_CONFIG
