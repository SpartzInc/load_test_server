class CreateTestResultResponseTimes < ActiveRecord::Migration
  def change
    create_table :test_result_response_times do |t|
      t.belongs_to :test_result, index: true
      t.datetime :datapoint_timestamp
      t.decimal :response_time

      t.timestamps
    end
  end
end
