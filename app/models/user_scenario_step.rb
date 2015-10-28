class UserScenarioStep < ActiveRecord::Base
  belongs_to :user_scenario

  has_many :scenario_step_request_params, :dependent => :destroy
  accepts_nested_attributes_for :scenario_step_request_params, :reject_if => :all_blank, :allow_destroy => true

  validates :request_url, presence: true
  validates :request_type, presence: true
  validates :step_order, presence: true, uniqueness: { scope: :user_scenario }
end
