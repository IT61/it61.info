class UrlValidator < ActiveModel::Validator
  def validate(record)
    begin
      URI.parse(record.url)
      true
    rescue
      "URL is not valid"
      false
    end
  end
end
