class TimeParams
  class << self
    def flatten_date_array(hash, key)
      %w(1 2 3).map { |e| hash["#{key}(#{e}i)"].to_i }
    end

    def flatten_time_array(hash, key)
      %w(1 2 3 4 5 6).map { |e| hash["#{key}(#{e}i)"].to_i }
    end

    def flatten_datetime_array(hash, date_key, time_key)
      TimeParams.flatten_date_array(hash, date_key) + TimeParams.flatten_time_array(hash, time_key).drop(3)
    end
  end
end
