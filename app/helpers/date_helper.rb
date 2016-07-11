module DateHelper


  def date_from_date_select_params(date_params, key)
    string_from_date_select_params(date_params, key).to_date
  end

  def date_time_from_date_time_select_params(date_params, key)
    string_from_date_select_params(date_params, key).to_datetime
  end

  private

    def string_from_date_select_params(params, key)
      date_parts = params.select { |k,v| k.to_s =~ /\A#{key}\([1-6]{1}i\)/ }.values
      date_parts[0..2].join('-') + ' ' + date_parts[3..-1].join(':')
    end

end
