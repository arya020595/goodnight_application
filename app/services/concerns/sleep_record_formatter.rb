module SleepRecordFormatter
  extend ActiveSupport::Concern

  def format_sleep_records(sleep_records)
    sleep_records.map do |record|
      duration_seconds = calculate_duration(record)
      {
        user_id: record.user.id,
        user_name: record.user.name,
        clock_in: record.clock_in,
        clock_out: record.clock_out,
        duration: {
          total_seconds: duration_seconds,
          hours: (duration_seconds / 3600).floor,
          minutes: ((duration_seconds % 3600) / 60).round,
          category: classify_sleep(duration_seconds)
        }
      }
    end
  end

  private

  def calculate_duration(record)
    record.clock_out - record.clock_in
  end

  def classify_sleep(duration_seconds)
    if duration_seconds < 6.hours.to_i
      'short sleep'
    elsif duration_seconds.between?(6.hours.to_i, 9.hours.to_i)
      'normal sleep'
    else
      'long sleep'
    end
  end
end
