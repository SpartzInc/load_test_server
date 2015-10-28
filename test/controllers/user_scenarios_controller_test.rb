require 'test_helper'

class UserScenariosControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @user_scenario = user_scenarios(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_scenarios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
=begin TODO: eventually fix
  test "should create user_scenario" do
    assert_difference('UserScenario.count') do
      post :create, user_scenario:
                      {
                          name: @user_scenario.name + rand(1..1000000).to_s
                      }
    end

    assert_redirected_to user_scenario_path(assigns(:user_scenario))
  end
=end
  test "should show user_scenario" do
    get :show, id: @user_scenario
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_scenario
    assert_response :success
  end

  test "should update user_scenario" do
    patch :update,
          id: @user_scenario,
          user_scenario:
              {
                  name: @user_scenario.name + rand(1..1000000).to_s
              }

    assert_redirected_to user_scenario_path(assigns(:user_scenario))
  end

  test "should destroy user_scenario" do
    assert_difference('UserScenario.count', -1) do
      delete :destroy, id: @user_scenario
    end

    assert_redirected_to user_scenarios_path
  end
end
