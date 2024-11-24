# app/services/sleep_record_service.rb
class SleepRecordService
  include SleepRecordFormatter
  include FormatDuration

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
    sleep_records = fetch_records(user_id, page, per)
    insights = calculate_analytical_insights(sleep_records)
    classified_records = format_sleep_records(sleep_records)

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
      average_duration: average_duration ? format_duration_in_hours_and_minutes(average_duration) : nil,
      min_duration: min_duration ? format_duration_in_hours_and_minutes(min_duration) : nil,
      max_duration: max_duration ? format_duration_in_hours_and_minutes(max_duration) : nil
    }
  end
end
