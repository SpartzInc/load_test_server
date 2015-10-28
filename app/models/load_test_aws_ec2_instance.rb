class LoadTestAwsEc2Instance < ActiveRecord::Base
  belongs_to :load_test
  belongs_to :aws_ec2_instance

  validates :metric, uniqueness: {:scope => [:load_test, :aws_ec2_instance]}, presence: true
end
