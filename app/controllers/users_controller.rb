class UsersController < ApplicationController
  def follow
    follow = Follow.new(follower_id: params[:id], followed_id: follow_params[:followed_id])
    if follow.save
      render json: { message: 'Followed successfully' }, status: :created
    else
      render json: { errors: follow.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unfollow
    follow = Follow.find_by(follower_id: params[:id], followed_id: follow_params[:followed_id])
    if follow&.destroy
      render json: { message: 'Unfollowed successfully' }, status: :ok
    else
      render json: { errors: 'Unable to unfollow' }, status: :unprocessable_entity
    end
  end

  def followings_sleep_records
    user = User.find(params[:id])
    followings = user.followed_users

    # Using Arel for safe SQL expression
    sleep_record_duration = Arel.sql('clock_out - clock_in')

    # Fetch sleep records from the last week, ordered by duration
    sleep_records = SleepRecord.where(user: followings)
                               .where('clock_in >= ?', 1.week.ago)
                               .order(sleep_record_duration.desc) # Use Arel for ordering

    # Prepare the response
    result = sleep_records.map do |record|
      {
        user_id: record.user.id,
        user_name: record.user.name,
        clock_in: record.clock_in,
        clock_out: record.clock_out,
        duration: record.clock_out - record.clock_in
      }
    end

    render json: result
  end

  private

  def follow_params
    params.require(:follow).permit(:followed_id)
  end
end
