class AwsRdsInstance < ActiveRecord::Base
  belongs_to :aws_account

  has_many :load_test_aws_rds_instances, :dependent => :destroy
  has_many :test_result_aws_rds_instances, :dependent => :destroy

  validates :name, uniqueness: {scope: :aws_account}, presence: true
  validates :db_instance_identifier, uniqueness: {scope: :aws_account}, presence: true

  def full_name
    return "#{self.aws_account.name} (#{self.name})"
  end
end
