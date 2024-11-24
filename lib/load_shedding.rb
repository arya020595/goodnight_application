class LoadShedding
  MAX_REQUESTS_PER_MINUTE = 10_000 # Threshold to trigger load shedding

  def self.should_shed_load?
    current_requests = REDIS.get('system_requests_count').to_i

    if current_requests > MAX_REQUESTS_PER_MINUTE
      true # Shed load, stop processing further requests
    else
      REDIS.incr('system_requests_count')
      REDIS.expire('system_requests_count', 1.minute.to_i)
      false # Allow requests
    end
  end
end
