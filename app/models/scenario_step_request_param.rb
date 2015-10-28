class ScenarioStepRequestParam < ActiveRecord::Base
  belongs_to :user_scenario_step

  validates :request_key, uniqueness: {scope: :user_scenario_step}, presence: true
end
