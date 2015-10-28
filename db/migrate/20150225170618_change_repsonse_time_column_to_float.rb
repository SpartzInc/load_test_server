class ChangeRepsonseTimeColumnToFloat < ActiveRecord::Migration
  def change
    change_column :test_result_response_times, :response_time, :float
  end
end
