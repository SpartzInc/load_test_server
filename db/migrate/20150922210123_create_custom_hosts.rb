class CreateCustomHosts < ActiveRecord::Migration
  def change
    create_table :custom_hosts do |t|
      t.string :hostname
      t.string :ip_address
      t.boolean :active, default: false
      t.text  :description

      t.timestamps
    end
  end
end
