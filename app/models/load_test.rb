class LoadTest < ActiveRecord::Base
  belongs_to :user_scenario
  validates :user_scenario, presence: true

  has_many :load_test_schedules, :dependent => :destroy
  accepts_nested_attributes_for :load_test_schedules, :reject_if => :all_blank, :allow_destroy => true

  validate do |load_test|
    load_test.errors.add(:base, 'Need at least one load test schedule') if load_test.load_test_schedules.length == 0
  end

  has_many :load_test_aws_ec2_instances, :dependent => :destroy
  accepts_nested_attributes_for :load_test_aws_ec2_instances, :reject_if => :all_blank, :allow_destroy => true

  has_many :aws_ec2_instances, :through => :load_test_aws_ec2_instances

  has_many :load_test_aws_rds_instances, :dependent => :destroy
  accepts_nested_attributes_for :load_test_aws_rds_instances, :reject_if => :all_blank, :allow_destroy => true

  has_many :aws_rds_instances, :through => :load_test_aws_rds_instances

  has_many :test_schedules, :dependent => :destroy

  validates :name, uniqueness: true, presence: true

  def schedule_graph_set
    schedule_set = Array.new
    schedule_set.push([0, 0])

    relative_time = 0

    self.load_test_schedules.each { |load_test_schedule|
      relative_time += load_test_schedule.duration
      schedule_set.push([relative_time, load_test_schedule.maximum_virtual_users])
    }
    return schedule_set
  end

  class << self
    def load_test_name_options
      names_sort = [['All', 'all']]

      test_names = self.select(:name).distinct
      test_names = test_names.map { |test_name| [test_name.name, test_name.name] }.sort
      test_names.each do |test_name|
        names_sort.push(test_name)
      end

      return names_sort
    end
  end
end
