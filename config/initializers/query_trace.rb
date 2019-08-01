if Rails.configuration.respond_to?(:use_query_trace) && Rails.configuration.use_query_trace
  require "active_record_query_trace"

  ActiveRecordQueryTrace.enabled = true
  ActiveRecordQueryTrace.colorize = :light_purple
end
