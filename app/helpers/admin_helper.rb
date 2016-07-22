module AdminHelper

  def format_time(time)
    time.strftime '%d.%m.%Y %H:%M'
  end

end