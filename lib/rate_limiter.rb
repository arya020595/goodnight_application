class RateLimiter
  MAX_REQUESTS = 100
  TIME_WINDOW = 1.hour

  def self.allowed?(user_id)
    key = "rate_limit:#{user_id}"
    current_count = REDIS.get(key).to_i

    if current_count >= MAX_REQUESTS
      # Throttle by introducing a delay (e.g., 1 second)
      sleep(1)
      return false
    end

    # Increment the counter and set expiration if it's the first request
    REDIS.multi do
      REDIS.incr(key)
      REDIS.expire(key, TIME_WINDOW.to_i) if current_count.zero?
    end

    true
  end
end
