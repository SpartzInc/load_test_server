class ModifyTestScheduleColumnsForStatusesDefault < ActiveRecord::Migration
  def change
    change_column :test_schedules, :failed, :boolean, :default => false
  end
end
