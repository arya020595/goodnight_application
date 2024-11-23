# app/services/user_service.rb
class UserService
  # Follow a user
  def follow(followed_id, user_id)
    user = User.find(user_id)
    follow = Follow.new(follower_id: user.id, followed_id: followed_id)

    if follow.save
      { success: true, message: 'Followed successfully', user: user, follow: follow }
    else
      { success: false, errors: follow.errors.full_messages }
    end
  end

  # Unfollow a user
  def unfollow(followed_id, user_id)
    user = User.find(user_id)
    follow = Follow.find_by(follower_id: user.id, followed_id: followed_id)

    if follow&.destroy
      { success: true, message: 'Unfollowed successfully', user: user, follow: follow }
    else
      { success: false, errors: 'Unable to unfollow' }
    end
  end

  # Fetch sleep records of all followings with pagination metadata
  def followings_sleep_records(user_id, page, per)
    user = User.find(user_id)
    followings = user.followed_users

    sleep_records = SleepRecord.where(user: followings)
                               .from_last_week
                               .order_by_duration
                               .includes(:user)
                               .page(page)
                               .per(per)

    # Prepare sleep records in the desired format
    formatted_sleep_records = format_sleep_records(sleep_records)

    # Return both formatted sleep records and pagination metadata
    {
      success: true,
      data: formatted_sleep_records,
      meta: {
        current_page: sleep_records.current_page,
        total_pages: sleep_records.total_pages,
        total_count: sleep_records.total_count
      }
    }
  end

  # Calculate the average sleep duration of a user
  def average_sleep_duration(user_id)
    user = User.find(user_id)

    # Calculate the average duration (in seconds) from sleep records in the last week
    average_duration_seconds = user.sleep_records.from_last_week.average(Arel.sql('clock_out - clock_in')).to_f

    # Guard clause: return error if no sleep data is available
    if average_duration_seconds <= 0
      return {
        success: false,
        data: { message: 'No sleep data available for user' }
      }
    end

    # Calculate hours and minutes from the average duration in seconds
    hours = (average_duration_seconds / 3600).floor
    minutes = ((average_duration_seconds % 3600) / 60).round

    # Return the result with detailed user information
    {
      success: true,
      data: {
        user_id: user.id,
        user_name: user.name,
        hours: hours,
        minutes: minutes
      }
    }
  end

  private

  # Format the sleep records into the required format
  # Format sleep records with readable and analytical duration
  def format_sleep_records(sleep_records)
    sleep_records.map do |record|
      duration_seconds = record.clock_out - record.clock_in
      hours = (duration_seconds / 3600).floor
      minutes = ((duration_seconds % 3600) / 60).round

      # Add analytical insights based on the duration
      duration_category = if duration_seconds < 6.hours.to_i
                            'short sleep'
                          elsif duration_seconds.between?(6.hours.to_i, 9.hours.to_i)
                            'normal sleep'
                          else
                            'long sleep'
                          end

      {
        user_id: record.user.id,
        user_name: record.user.name,
        clock_in: record.clock_in,
        clock_out: record.clock_out,
        duration: {
          total_seconds: duration_seconds,
          hours: hours,
          minutes: minutes,
          category: duration_category
        }
      }
    end
  end
end
