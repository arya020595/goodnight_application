# app/services/user_service.rb
class UserService
  include SleepRecordFormatter
  include FormatDuration

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

    # Fetch sleep records from the last week
    sleep_records = user.sleep_records.from_last_week

    # Guard clause: return error if no sleep data is available
    if sleep_records.empty?
      return {
        success: false,
        data: { message: 'No sleep data available for user' }
      }
    end

    # Calculate the average duration (in seconds)
    average_duration_seconds = sleep_records.average(Arel.sql('clock_out - clock_in')).to_f

    # Format the average duration into hours and minutes
    formatted_duration = format_duration_in_hours_and_minutes(average_duration_seconds)

    # Return the result with detailed user information
    {
      success: true,
      data: {
        user_id: user.id,
        user_name: user.name,
        hours: formatted_duration[:hours],
        minutes: formatted_duration[:minutes]

      }
    }
  end
end
