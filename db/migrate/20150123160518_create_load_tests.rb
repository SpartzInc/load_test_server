class CreateLoadTests < ActiveRecord::Migration
  def change
    create_table :load_tests do |t|
      t.belongs_to :user_scenario, index: true
      t.string :name

      t.timestamps
    end
  end
end
