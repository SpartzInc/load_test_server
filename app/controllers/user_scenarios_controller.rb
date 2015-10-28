class UserScenariosController < ApplicationController
  before_action :set_user_scenario, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @user_scenarios = UserScenario.all.paginate(:page => params['page']).order('updated_at DESC')
    respond_with(@user_scenarios)
  end

  def show
    respond_with(@user_scenario)
  end

  def new
    @user_scenario = UserScenario.new
    respond_with(@user_scenario)
  end

  def edit
  end

  def create
    @user_scenario = UserScenario.new(user_scenario_params)
    @user_scenario.save
    respond_with(@user_scenario)
  end

  def update
    @user_scenario.update(user_scenario_params)
    respond_with(@user_scenario)
  end

  def destroy
    @user_scenario.destroy
    respond_with(@user_scenario)
  end

  private
  def set_user_scenario
    @user_scenario = UserScenario.find(params[:id])
  end

  def user_scenario_params
    params.require(:user_scenario).permit(:name,
                                          user_scenario_steps_attributes:
                                              [:id, :request_url, :request_type, :step_order, :_destroy,
                                             scenario_step_request_params_attributes:
                                               [:id, :request_key, :request_value, :_destroy]])
  end
end
