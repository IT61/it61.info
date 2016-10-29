class InstagramCache < ApplicationRecord
  def self.get(tag)
    json_string = $redis.get(tag)
    JSON.parse json_string unless json_string.blank?
  end

  def self.store(tag, response)
    $redis.set(tag, response.to_json)
    $redis.expire(tag, 5.days)
  end
end
