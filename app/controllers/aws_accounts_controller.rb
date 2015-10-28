class AwsAccountsController < ApplicationController
  before_action :set_aws_account, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @aws_accounts = AwsAccount.all.paginate(:page => params['page']).order('updated_at DESC')
    respond_with(@aws_accounts)
  end

  def show
    respond_with(@aws_account)
  end

  def new
    @aws_account = AwsAccount.new
    respond_with(@aws_account)
  end

  def edit
  end

  def create
    @aws_account = AwsAccount.new(aws_account_params)
    @aws_account.save
    respond_with(@aws_account)
  end

  def update
    @aws_account.update(aws_account_params)
    respond_with(@aws_account)
  end

  def destroy
    @aws_account.destroy
    respond_with(@aws_account)
  end

  private
  def set_aws_account
    @aws_account = AwsAccount.find(params[:id])
  end

  def aws_account_params
    params.require(:aws_account).permit(:name, :access_key_id, :secret_access_key,
                                        aws_rds_instances_attributes:
                                            [:id, :name, :db_instance_identifier, :_destroy],
                                        aws_ec2_instances_attributes:
                                            [:id, :name, :instance_id, :_destroy])
  end
end
