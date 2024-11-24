class ApplicationController < ActionController::API
  before_action :check_rate_limit, :check_load_shedding

  private

  def check_rate_limit
    user_id = request.remote_ip # You can use user ID if you're tracking authenticated users, or use IP

    return if RateLimiter.allowed?(user_id)

    render json: { message: 'Rate limit exceeded. Please try again later.' }, status: :too_many_requests
  end

  def check_load_shedding
    return unless LoadShedding.should_shed_load?

    render json: { message: 'Server is under heavy load. Please try again later.' }, status: :service_unavailable
  end
end
