# app/services/concerns/format_duration.rb
module FormatDuration
  extend ActiveSupport::Concern

  # Helper to convert seconds into hours and minutes
  def format_duration_in_hours_and_minutes(duration)
    hours = (duration / 3600).floor
    minutes = ((duration % 3600) / 60).round
    { hours: hours, minutes: minutes }
  end
end
