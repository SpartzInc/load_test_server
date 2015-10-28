class CreateScenarioStepRequestParams < ActiveRecord::Migration
  def change
    create_table :scenario_step_request_params do |t|
      t.references :user_scenario_step, index: true
      t.string :request_key
      t.string :request_value

      t.timestamps
    end
  end
end
