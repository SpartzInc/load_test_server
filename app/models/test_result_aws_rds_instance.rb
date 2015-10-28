class TestResultAwsRdsInstance < ActiveRecord::Base
  belongs_to :test_result

  belongs_to :aws_rds_instance
  validates :aws_rds_instance, presence: true

  has_many :aws_rds_instance_datas, -> { order(datapoint_timestamp: :asc) }, :dependent => :destroy
  accepts_nested_attributes_for :aws_rds_instance_datas, :reject_if => :all_blank, :allow_destroy => true

  validates :metric, presence: true

  validates_datetime :start_time
  validates_datetime :end_time
  validates_datetime :end_time, :after => :start_time

  after_save :clean_and_load_data

  def clean_and_load_data
    self.aws_rds_instance_datas.each { |aws_rds_instance_data|
      aws_rds_instance_data.destroy
    }

    AWS.config(access_key_id: self.aws_rds_instance.aws_account.access_key_id,
               secret_access_key: self.aws_rds_instance.aws_account.secret_access_key)

    metric = AWS::CloudWatch::Metric.new('AWS/RDS',
                                         self.metric,
                                         :dimensions => [{:name => 'DBInstanceIdentifier',
                                                          :value => self.aws_rds_instance.db_instance_identifier}])

    stats = metric.statistics(:start_time => self.start_time - 500, :end_time => self.end_time,
                              :statistics => ['Average'], :period => 60)

    ActiveRecord::Base.transaction do
      stats.each { |data_point|
        AwsRdsInstanceData.create({
                                      :test_result_aws_rds_instance_id => self.id,
                                      :datapoint_timestamp => data_point[:timestamp],
                                      :datapoint_unit => data_point[:unit],
                                      :datapoint_average => data_point[:average],

                                  })
      }
    end
  end

  def graph_set
    graph_set = Array.new

    self.aws_rds_instance_datas.each { |aws_rds_instance_data|
      graph_set.push([aws_rds_instance_data.datapoint_timestamp, aws_rds_instance_data.datapoint_average])
    }

    return graph_set
  end

  def formatted_name
    return self.aws_rds_instance.full_name + ', Metric: ' + self.metric
  end
end
