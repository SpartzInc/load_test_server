class TestResultsController < ApplicationController
  before_action :set_test_result, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @load_test_name_options = LoadTest.load_test_name_options
    @test_results = get_filtered_results
    respond_with(@test_results)
  end

  def get_filtered_results
    if params['filter']
      @filter = params['filter']
      if @filter == 'all'
        return TestResult.all.paginate(:page => params['page']).order('created_at DESC')
      else
        return TestResult.load_test_filter(@filter).all.paginate(:page => params['page']).order('created_at DESC') #reverse chronological
      end
    else
      @filter = 'all'
      return TestResult.all.paginate(:page => params['page']).order('created_at DESC') #reverse chronological
    end
  end

  def show
    respond_with(@test_result)
  end

  def new
    @test_result = TestResult.new
    respond_with(@test_result)
  end

  def edit
  end

  def create
    @test_result = TestResult.new(test_result_params)
    @test_result.save
    respond_with(@test_result)
  end

  def update
    @test_result.update(test_result_params)
    respond_with(@test_result)
  end

  def destroy
    @test_result.destroy
    respond_with(@test_result)
  end

  private
  def set_test_result
    @test_result = TestResult.find(params[:id])
  end

  def test_result_params
    params.require(:test_result).permit(:test_schedule_id, :in_progress,

                                        test_result_aws_ec2_instances_attributes:
                                          [:id, :aws_ec2_instance_id, :metric, :start_time, :end_time, :_destroy,

                                           aws_ec2_instance_datas_attributes:
                                             [:id, :datapoint_timestamp, :datapoint_unit, :datapoint_average, :_destroy]],

                                        test_result_aws_rds_instances_attributes:
                                          [:id, :aws_rds_instance_id, :metric, :start_time, :end_time, :_destroy,

                                           aws_rds_instance_datas_attributes:
                                             [:id, :datapoint_timestamp, :datapoint_unit, :datapoint_average, :_destroy]])
  end
end