class CreateUserScenarios < ActiveRecord::Migration
  def change
    create_table :user_scenarios do |t|
      t.string :name

      t.timestamps
    end
  end
end
