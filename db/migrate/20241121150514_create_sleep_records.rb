class CreateSleepRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :sleep_records do |t|
      t.integer :user_id
      t.datetime :clock_in
      t.datetime :clock_out

      t.timestamps
    end
  end
end
