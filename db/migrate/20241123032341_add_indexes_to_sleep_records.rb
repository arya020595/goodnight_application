class AddIndexesToSleepRecords < ActiveRecord::Migration[7.1]
  def change
    add_index :sleep_records, :user_id
    add_index :sleep_records, :clock_in
  end
end
