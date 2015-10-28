class UserScenario < ActiveRecord::Base
  has_many :load_tests, :dependent => :destroy

  has_many :user_scenario_steps, -> { order(:step_order => :asc) }, :dependent => :destroy
  accepts_nested_attributes_for :user_scenario_steps, :reject_if => :all_blank, :allow_destroy => true
  validate do |test|
    test.errors.add(:base, 'Need at least one step') if test.user_scenario_steps.length == 0
  end

  validates :name, uniqueness: true, presence: true
end