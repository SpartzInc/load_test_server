class CreateAwsEc2Instances < ActiveRecord::Migration
  def change
    create_table :aws_ec2_instances do |t|
      t.references :aws_account, index: true
      t.string :name
      t.string :instance_id

      t.timestamps
    end
  end
end
