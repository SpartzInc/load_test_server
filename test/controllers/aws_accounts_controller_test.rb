require 'test_helper'

class AwsAccountsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @aws_account = aws_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:aws_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create aws_account" do
    assert_difference('AwsAccount.count') do
      post :create,
           aws_account:
               {
                   name: @aws_account.name + rand(1..1000000).to_s,
                   access_key_id: @aws_account.encrypted_access_key_id,
                   secret_access_key: @aws_account.encrypted_secret_access_key
               }
    end

    assert_redirected_to aws_account_path(assigns(:aws_account))
  end

  test "should show aws_account" do
    get :show, id: @aws_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @aws_account
    assert_response :success
  end

  test "should update aws_account" do
    patch :update,
          id: @aws_account,
          aws_account:
              {
                  name: @aws_account.name + rand(1..1000000).to_s,
                  access_key_id: @aws_account.encrypted_access_key_id,
                  secret_access_key: @aws_account.encrypted_secret_access_key
              }

    assert_redirected_to aws_account_path(assigns(:aws_account))
  end

  test "should destroy aws_account" do
    assert_difference('AwsAccount.count', -1) do
      delete :destroy, id: @aws_account
    end

    assert_redirected_to aws_accounts_path
  end
end
