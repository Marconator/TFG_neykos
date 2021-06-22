class GatewayAliveController < ApplicationController
  before_action :set_hardware, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /gateway_alive
  # GET /gateway_alive.json
  def index
    gateway_alive = GatewayAlive.all
    render json: gateway_alive.to_json(:except => [:id])
  end

  # POST /gateway_alive
  # POST /gateway_alive.json
  def create
    gateway_alive = GatewayAlive.create(gateway_id: params[:gatewayId])
    render json: gateway_alive.to_json, status: :ok
  end

end
