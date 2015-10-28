class CustomHostsController < ApplicationController
  before_action :set_custom_host, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @custom_hosts = CustomHost.order(:hostname, active: :desc)
    # @hosts_json = @custom_hosts.as_json
    respond_with(@custom_hosts)
  end

  # def show
  #   respond_with(@custom_host)
  # end

  def new
    @custom_host = CustomHost.new
    respond_with(@custom_host)
  end

  def edit
  end

  def create
    @custom_host = CustomHost.new(strong_custom_host_params)
    if @custom_host.save
      redirect_to custom_hosts_path
    else
      respond_with(@custom_host)
    end
  end

  def update
    if request.xhr?
      p params
      # p params.class
      # p ajax_custom_host_params

      @custom_host.update(strong_custom_host_params) # strong params - see below
      render json: {host: @custom_host, ghostList: `ghost list`}
    else
      if @custom_host.update(strong_custom_host_params)
        redirect_to custom_hosts_path
      else
        respond_with(@custom_host)
      end
    end
  end

  def destroy
    @custom_host.destroy
    respond_with(@custom_host)
  end

  private
    def set_custom_host
      @custom_host = CustomHost.find(params[:id])
    end

    def custom_host_params
      params[:custom_host]
    end

    # !!! I added this. why no strong params in scaffolded method above?
    def strong_custom_host_params
      params.require(:custom_host).permit(:id, :active, :description, :hostname, :ip_address)
    end
end
