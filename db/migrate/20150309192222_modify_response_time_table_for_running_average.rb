class ModifyResponseTimeTableForRunningAverage < ActiveRecord::Migration
  def change
    rename_column :test_result_response_times, :response_time, :response_time_sum
    add_column :test_result_response_times, :number_of_times, :integer, :after => :response_time_sum
  end
end
