class AwsAccount < ActiveRecord::Base
  after_validation :modify_errors_for_api_keys

  attr_encrypted :access_key_id, random_iv: true
  attr_encrypted :secret_access_key, random_iv: true

  has_many :aws_ec2_instances, :dependent => :destroy
  accepts_nested_attributes_for :aws_ec2_instances, :reject_if => :all_blank, :allow_destroy => true

  has_many :aws_rds_instances, :dependent => :destroy
  accepts_nested_attributes_for :aws_rds_instances, :reject_if => :all_blank, :allow_destroy => true

  validates :name, uniqueness: true, presence: true
  validates :encrypted_access_key_id, presence: true
  validates :encrypted_secret_access_key, presence: true

  #Override update, for protecting Access Key ID and Secret Access Key
  #This way, the form doesn't need those values in order to save
  def update(params)
    params.delete(:access_key_id) if params[:access_key_id].empty?
    params.delete(:secret_access_key) if params[:secret_access_key].empty?

    super
  end

  def modify_errors_for_api_keys
    if self.errors.get(:encrypted_access_key_id)
      self.errors.add(:access_key_id, self.errors.get(:encrypted_access_key_id).join(' '))
      self.errors.delete(:encrypted_access_key_id)
    end

    if self.errors.get(:encrypted_secret_access_key)
      self.errors.add(:secret_access_key, self.errors.get(:encrypted_secret_access_key).join(' '))
      self.errors.delete(:encrypted_secret_access_key)
    end
  end
end
