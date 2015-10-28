require 'test_helper'

class LoadTestsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @load_test = load_tests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:load_tests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
=begin TODO: eventually fix
  test "should create load_test" do
    assert_difference('LoadTest.count') do
      post :create,
           load_test:
               {
                   name: @load_test.name + rand(1..1000000).to_s,
                   user_scenario_id: @load_test.user_scenario_id
               }
    end

    assert_redirected_to load_test_path(assigns(:load_test))
  end
=end
  test "should show load_test" do
    get :show, id: @load_test
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @load_test
    assert_response :success
  end

  test "should update load_test" do
    patch :update, id: @load_test, load_test:
                     {
                         name: @load_test.name + rand(1..1000000).to_s,
                         user_scenario_id: @load_test.user_scenario_id
                     }
    assert_redirected_to load_test_path(assigns(:load_test))
  end

  test "should destroy load_test" do
    assert_difference('LoadTest.count', -1) do
      delete :destroy, id: @load_test
    end

    assert_redirected_to load_tests_path
  end
end
