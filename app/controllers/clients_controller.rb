class ClientsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /gateway
  def index
      @clients = Client.all

      if request.xhr?
        respond_to do |format|
          format.json {
            render json: {clients: @clients.as_json(:include => [:gateways => {:include => :devices}]) }
          }
        end
      end
  end


end
