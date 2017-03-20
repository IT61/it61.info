if Rails.configuration.respond_to?(:use_query_trace) && Rails.configuration.use_query_trace
  require "active_record_query_trace"

  ActiveRecordQueryTrace.enabled = true
  ActiveRecordQueryTrace.colorize = "light purple"
  ActiveRecordQueryTrace.colorize = true # Colorize in default color
  ActiveRecordQueryTrace.colorize = 35 # Magenta
end
