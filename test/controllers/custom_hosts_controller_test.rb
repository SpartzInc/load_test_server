require 'test_helper'

class CustomHostsControllerTest < ActionController::TestCase
  setup do
    @custom_host = custom_hosts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:custom_hosts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create custom_host" do
    assert_difference('CustomHost.count') do
      post :create, custom_host: {  }
    end

    assert_redirected_to custom_host_path(assigns(:custom_host))
  end

  test "should show custom_host" do
    get :show, id: @custom_host
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @custom_host
    assert_response :success
  end

  test "should update custom_host" do
    patch :update, id: @custom_host, custom_host: {  }
    assert_redirected_to custom_host_path(assigns(:custom_host))
  end

  test "should destroy custom_host" do
    assert_difference('CustomHost.count', -1) do
      delete :destroy, id: @custom_host
    end

    assert_redirected_to custom_hosts_path
  end
end
