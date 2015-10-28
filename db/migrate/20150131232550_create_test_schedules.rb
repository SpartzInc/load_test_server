class CreateTestSchedules < ActiveRecord::Migration
  def change
    create_table :test_schedules do |t|
      t.belongs_to :load_test, index: true
      t.boolean :schedule_now
      t.datetime :schedule_at
      t.boolean :started
      t.boolean :complete

      t.timestamps
    end
  end
end
