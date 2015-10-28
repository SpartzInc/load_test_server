class ModifyDefaultsTestScheduleTable < ActiveRecord::Migration
  def change
    change_column :test_schedules, :schedule_now, :boolean, :default => true
    change_column :test_schedules, :started, :boolean, :default => false
    change_column :test_schedules, :complete, :boolean, :default => false
    change_column :test_schedules, :cancel, :boolean, :default => false
  end
end
