class CreateAwsAccounts < ActiveRecord::Migration
  def change
    create_table :aws_accounts do |t|
      t.string :name
      t.text :encrypted_access_key_id
      t.text :encrypted_secret_access_key

      t.timestamps
    end
  end
end
