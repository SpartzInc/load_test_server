class CreateTestResultResponseCodes < ActiveRecord::Migration
  def change
    create_table :test_result_response_codes do |t|
      t.belongs_to :test_result, index: true
      t.datetime :datapoint_timestamp
      t.integer :response_code

      t.timestamps
    end
  end
end
