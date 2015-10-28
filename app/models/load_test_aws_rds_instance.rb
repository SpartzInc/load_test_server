class LoadTestAwsRdsInstance < ActiveRecord::Base
  belongs_to :load_test
  belongs_to :aws_rds_instance

  validates :metric, uniqueness: {:scope => [:load_test, :aws_rds_instance]}, presence: true
end
