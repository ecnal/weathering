class CacheService
  def self.get(key)
    Rails.cache.read(key)
  end

  def self.set(key, data, expiration)
    Rails.cache.write(key, data, expires_in: expiration)
  end
end
