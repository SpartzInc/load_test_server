class AdditionalColumnsTestSchedule < ActiveRecord::Migration
  def change
    add_column :test_schedules, :cancel, :boolean, :after => :complete
    add_column :test_schedules, :start_time, :datetime, :after => :cancel
    add_column :test_schedules, :end_time, :datetime, :after => :start_time
  end
end
