class CreateLoadTestAwsEc2Instances < ActiveRecord::Migration
  def change
    create_table :load_test_aws_ec2_instances do |t|
      t.belongs_to :load_test, index: true
      t.belongs_to :aws_ec2_instance, index: true
      t.string :metric

      t.timestamps
    end
  end
end
