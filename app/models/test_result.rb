class TestResult < ActiveRecord::Base
  belongs_to :test_schedule
  validates :test_schedule, :presence => true

  has_one :load_test, :through => :test_schedule

  has_many :test_result_aws_ec2_instances, :dependent => :destroy
  accepts_nested_attributes_for :test_result_aws_ec2_instances, :reject_if => :all_blank, :allow_destroy => true

  has_many :test_result_aws_rds_instances, :dependent => :destroy
  accepts_nested_attributes_for :test_result_aws_rds_instances, :reject_if => :all_blank, :allow_destroy => true

  has_many :test_result_response_codes, :dependent => :destroy
  accepts_nested_attributes_for :test_result_response_codes, :reject_if => :all_blank, :allow_destroy => true

  has_many :test_result_response_times, :dependent => :destroy
  accepts_nested_attributes_for :test_result_response_times, :reject_if => :all_blank, :allow_destroy => true

  scope :load_test_filter, -> (name) {
    joins(:load_test).where('name = ?', name)
  }

  def response_times_graph_set
    graph_set = Array.new

    self.test_result_response_times.each { |response_time|
      graph_set.push([response_time.datapoint_timestamp, (response_time.response_time_sum / response_time.number_of_times)])
    }

    return graph_set
  end

  def response_codes_graph_set
    graph_set = Array.new
    graph_series = Hash.new

    self.test_result_response_codes.each { |test_result_response_code|
      graph_series[test_result_response_code.response_code] = Array.new unless graph_series.has_key?(test_result_response_code.response_code)
      graph_series[test_result_response_code.response_code].push([test_result_response_code.datapoint_timestamp, test_result_response_code.number_of_times])
    }

    graph_series.each { |response_code, series_set|
      graph_set.push({name: "Response Code: #{response_code}", data: series_set})
    }

    return graph_set
  end

  def average_response_time
    number_of_times = self.test_result_response_times.sum(:number_of_times)
    response_time_sum = self.test_result_response_times.sum(:response_time_sum)

    return 0 if number_of_times == 0
    return response_time_sum / number_of_times
  end

  def total_requests
    self.test_result_response_codes.sum(:number_of_times)
  end
end