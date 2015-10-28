class AddFailedMessageToTestSchedule < ActiveRecord::Migration
  def change
    add_column :test_schedules, :failed_message, :text, :after => :failed
  end
end
