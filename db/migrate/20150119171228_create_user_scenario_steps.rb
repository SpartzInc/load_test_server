class CreateUserScenarioSteps < ActiveRecord::Migration
  def change
    create_table :user_scenario_steps do |t|
      t.references :user_scenario, index: true
      t.string :request_url
      t.string :request_type
      t.string :response_type
      t.boolean :download_resources
      t.text :ruby_script

      t.timestamps
    end
  end
end
