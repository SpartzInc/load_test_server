class TestSchedulesController < ApplicationController
  before_action :set_test_schedule, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @load_test_name_options = LoadTest.load_test_name_options
    @test_schedules = get_filtered_results
    respond_with(@test_schedules)
  end

  def get_filtered_results
    if params['filter']
      @filter = params['filter']
      if @filter == 'all'
        return TestSchedule.all.paginate(:page => params['page']).order('created_at DESC')
      else
        return TestSchedule.load_test_filter(@filter).all.paginate(:page => params['page']).order('created_at DESC') #reverse chronological
      end
    else
      @filter = 'all'
      return TestSchedule.all.paginate(:page => params['page']).order('created_at DESC') #reverse chronological
    end
  end

  def show
    respond_with(@test_schedule)
  end

  def new
    @test_schedule = TestSchedule.new
    respond_with(@test_schedule)
  end

  def edit
  end

  def create
    @test_schedule = TestSchedule.new(test_schedule_params)
    @test_schedule.save

    redirect_to test_schedules_path
  end

  def cancel
    @test_schedule = TestSchedule.find(params[:test_schedule_id])
    flash[:notice] = @test_schedule.cancel
    redirect_to test_schedules_path
  end

  def update
    @test_schedule.update(test_schedule_params)
    respond_with(@test_schedule)
  end

  def destroy
    @test_schedule.destroy
    respond_with(@test_schedule)
  end

  private
  def set_test_schedule
    @test_schedule = TestSchedule.find(params[:id])
  end

  def test_schedule_params
    params.require(:test_schedule).permit(:load_test_id, :schedule_now, :schedule_at, :started, :complete, :failed, :failed_message, :cancelled, :start_time, :end_time)
  end
end
