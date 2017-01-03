if Rails.configuration.respond_to?(:load_mini_profiler) && Rails.configuration.load_mini_profiler
  require "rack-mini-profiler"
  require "flamegraph"
  require "stackprof"

  begin
    require "memory_profiler"
  rescue => e
    STDERR.put "#{e} failed to require mini profiler"
  end

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end

if defined?(Rack::MiniProfiler)

  # note, we may want to add some extra security here that disables mini profiler in a multi hosted env unless user global admin
  #   raw_connection means results are not namespaced
  #
  # namespacing gets complex, cause mini profiler is in the rack chain way before multisite
  Rack::MiniProfiler.config.storage_instance = Rack::MiniProfiler::RedisStore.new($redis)
  skip = [
    /assets/,
    /\/avatar\//,
    /^\/logs/,
    /^\/uploads/,
    /^\/javascripts\//,
    /^\/images\//,
    /^\/stylesheets\//,
  ]

  # we DO NOT WANT mini-profiler loading on anything but real desktops and laptops
  # so let's rule out all handheld, tablet, and mobile devices
  Rack::MiniProfiler.config.pre_authorize_cb = lambda do |env|
    path = env["PATH_INFO"]

    (env["HTTP_USER_AGENT"] !~ /iPad|iPhone|Android/) &&
      !skip.any?{|re| re =~ path}
  end

  Rack::MiniProfiler.config.position = "left"
  Rack::MiniProfiler.config.backtrace_ignores ||= []
end
