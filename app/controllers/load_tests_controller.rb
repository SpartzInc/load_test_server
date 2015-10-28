class LoadTestsController < ApplicationController
  before_action :set_load_test, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @load_tests = LoadTest.all.paginate(:page => params['page']).order('updated_at DESC')
    respond_with(@load_tests)
  end

  def show
    respond_with(@load_test)
  end

  def new
    @load_test = LoadTest.new
    respond_with(@load_test)
  end

  def edit
  end

  def create
    @load_test = LoadTest.new(load_test_params)
    @load_test.save
    respond_with(@load_test)
  end

  def update
    @load_test.update(load_test_params)
    respond_with(@load_test)
  end

  def destroy
    @load_test.destroy
    respond_with(@load_test)
  end

  private
  def set_load_test
    @load_test = LoadTest.find(params[:id])
  end

  def load_test_params
    params.require(:load_test).permit(:user_scenario_id, :name,
                                      load_test_schedules_attributes: [:id, :maximum_virtual_users, :duration, :_destroy],
                                      load_test_aws_ec2_instances_attributes: [:id, :aws_ec2_instance_id, :metric, :_destroy],
                                      load_test_aws_rds_instances_attributes: [:id, :aws_rds_instance_id, :metric, :_destroy])
  end
end
