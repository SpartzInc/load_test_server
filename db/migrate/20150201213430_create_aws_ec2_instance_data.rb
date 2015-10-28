class CreateAwsEc2InstanceData < ActiveRecord::Migration
  def change
    create_table :aws_ec2_instance_data do |t|
      t.belongs_to :test_result_aws_ec2_instance, index: true
      t.datetime :datapoint_timestamp
      t.string :datapoint_unit
      t.decimal :datapoint_average

      t.timestamps
    end
  end
end
