class CreateAwsRdsInstances < ActiveRecord::Migration
  def change
    create_table :aws_rds_instances do |t|
      t.references :aws_account, index: true
      t.string :name
      t.string :db_instance_identifier

      t.timestamps
    end
  end
end
