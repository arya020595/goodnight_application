class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :clock_in, presence: true
  validates :clock_out, presence: true, comparison: { greater_than: :clock_in }
end
