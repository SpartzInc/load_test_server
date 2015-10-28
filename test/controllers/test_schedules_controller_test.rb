require 'test_helper'

class TestSchedulesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @test_schedule = test_schedules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:test_schedules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create test_schedule" do
    assert_difference('TestSchedule.count') do
      post :create,
           test_schedule:
               {
                   complete: @test_schedule.complete,
                   load_test_id: @test_schedule.load_test_id,
                   schedule_at: @test_schedule.schedule_at,
                   schedule_now: @test_schedule.schedule_now,
                   started: @test_schedule.started
               }
    end

    assert_redirected_to test_schedules_path
  end

  test "should show test_schedule" do
    get :show, id: @test_schedule
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @test_schedule
    assert_response :success
  end

  test "should update test_schedule" do
    patch :update,
          id: @test_schedule,
          test_schedule:
              {
                  complete: @test_schedule.complete,
                  load_test_id: @test_schedule.load_test_id,
                  schedule_at: @test_schedule.schedule_at,
                  schedule_now: @test_schedule.schedule_now,
                  started: @test_schedule.started
              }
    assert_redirected_to test_schedule_path(assigns(:test_schedule))
  end

  test "should destroy test_schedule" do
    assert_difference('TestSchedule.count', -1) do
      delete :destroy, id: @test_schedule
    end

    assert_redirected_to test_schedules_path
  end
end
