class AwsEc2Instance < ActiveRecord::Base
  belongs_to :aws_account

  has_many :load_test_aws_ec2_instances, :dependent => :destroy
  has_many :test_result_aws_ec2_instances, :dependent => :destroy

  validates :name, uniqueness: {scope: :aws_account}, presence: true
  validates :instance_id, uniqueness: {scope: :aws_account}, presence: true

  def full_name
    return "#{self.aws_account.name} (#{self.name})"
  end
end
