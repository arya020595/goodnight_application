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

  def fetch_sleep_records(user_id, page, per)
    # Fetch sleep records
    sleep_records = fetch_records(user_id, page, per)

    # Calculate analytical insights
    insights = calculate_analytical_insights(sleep_records)

    # Classify the sleep records based on duration
    classified_records = classify_sleep_records(sleep_records)

    # Return results with both sleep records and meta information
    {
      success: true,
      records: classified_records,
      meta: {
        current_page: sleep_records.current_page,
        total_pages: sleep_records.total_pages,
        total_count: sleep_records.total_count,
        average_duration: insights[:average_duration],
        min_duration: insights[:min_duration],
        max_duration: insights[:max_duration]
      }
    }
  end

  private

  # Fetch sleep records based on user_id, page, and per parameters
  def fetch_records(user_id, page, per)
    SleepRecord.where(user_id: user_id)
               .where.not(clock_in: nil)
               .recent_first
               .page(page)
               .per(per)
  end

  # Calculate average, min, and max durations for the sleep records
  def calculate_analytical_insights(sleep_records)
    durations = sleep_records.map { |record| record.clock_out - record.clock_in }
    average_duration = durations.sum / durations.size.to_f if durations.any?
    min_duration = durations.min
    max_duration = durations.max

    {
      average_duration: average_duration ? format_duration(average_duration) : nil,
      min_duration: min_duration ? format_duration(min_duration) : nil,
      max_duration: max_duration ? format_duration(max_duration) : nil
    }
  end

  # Classify each sleep record based on its duration (short, normal, long)
  def classify_sleep_records(sleep_records)
    sleep_records.map do |record|
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
  end

  # Classify sleep based on duration (short, normal, long)
  def classify_sleep(duration_seconds)
    if duration_seconds < 6.hours.to_i
      'short sleep'
    elsif duration_seconds.between?(6.hours.to_i, 9.hours.to_i)
      'normal sleep'
    else
      'long sleep'
    end
  end

  # Format a duration (in seconds) into hours and minutes
  def format_duration(duration_seconds)
    hours = (duration_seconds / 3600).floor
    minutes = ((duration_seconds % 3600) / 60).round
    { hours: hours, minutes: minutes }
  end
end
