# app/services/sleep_record_service.rb
class SleepRecordService
  # Create a new sleep record
  def create_sleep_record(sleep_record_params)
    sleep_record = SleepRecord.new(sleep_record_params)
    if sleep_record.save
      { success: true, sleep_record: sleep_record }
    else
      { success: false, errors: sleep_record.errors.full_messages }
    end
  end

  # Fetch sleep records with pagination and provide analytical insights
  def fetch_sleep_records(user_id, page, per)
    # Fetch sleep records
    sleep_records = SleepRecord.where(user_id: user_id)
                               .recent_first
                               .page(page)
                               .per(per)

    # Calculate analytical insights
    durations = sleep_records.map { |record| record.clock_out - record.clock_in }
    average_duration = durations.sum / durations.size.to_f if durations.any?
    min_duration = durations.min
    max_duration = durations.max

    # Classify the sleep records based on duration
    classified_records = sleep_records.map do |record|
      duration_seconds = record.clock_out - record.clock_in
      category = classify_sleep(duration_seconds)

      {
        user_id: record.user.id,
        user_name: record.user.name,
        clock_in: record.clock_in,
        clock_out: record.clock_out,
        duration: {
          total_seconds: duration_seconds,
          hours: (duration_seconds / 3600).floor,
          minutes: ((duration_seconds % 3600) / 60).round,
          category: category
        }
      }
    end

    # Return results with both sleep records and meta information
    {
      success: true,
      records: classified_records,
      meta: {
        current_page: sleep_records.current_page,
        total_pages: sleep_records.total_pages,
        total_count: sleep_records.total_count,
        average_duration: average_duration ? format_duration(average_duration) : nil,
        min_duration: min_duration ? format_duration(min_duration) : nil,
        max_duration: max_duration ? format_duration(max_duration) : nil
      }
    }
  end

  private

  # Classify sleep duration
  def classify_sleep(duration_seconds)
    if duration_seconds < 6.hours.to_i
      'short sleep'
    elsif duration_seconds.between?(6.hours.to_i, 9.hours.to_i)
      'normal sleep'
    else
      'long sleep'
    end
  end

  # Format duration in hours and minutes for analytical purposes
  def format_duration(duration_seconds)
    hours = (duration_seconds / 3600).floor
    minutes = ((duration_seconds % 3600) / 60).round
    { hours: hours, minutes: minutes }
  end
end
