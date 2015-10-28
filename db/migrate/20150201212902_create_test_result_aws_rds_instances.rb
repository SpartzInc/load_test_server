class CreateTestResultAwsRdsInstances < ActiveRecord::Migration
  def change
    create_table :test_result_aws_rds_instances do |t|
      t.belongs_to :test_result, index: true
      t.belongs_to :aws_rds_instance, index: true
      t.string :metric
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
