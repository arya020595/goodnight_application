class SleepRecord < ApplicationRecord
  belongs_to :user

  # Scope for records from the last week
  scope :from_last_week, -> { where('clock_in >= ?', 1.week.ago) }
  # Scope for ordering by creation time (most recent first)
  scope :recent_first, -> { order(created_at: :desc) }
  # Scope for sorting by sleep duration
  scope :order_by_duration, -> { order(Arel.sql('clock_out - clock_in DESC')) }

  validates :clock_in, presence: true
  validates :clock_out, presence: true, comparison: { greater_than: :clock_in }
end
