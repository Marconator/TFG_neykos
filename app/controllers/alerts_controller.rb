class AlertsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # GET /alerts
  # GET /alerts.json
  def index
    #Paging
    @page = (params[:page].presence != nil) ? params[:page].to_i : 1
    @limit = 10
    @offset = @limit*(@page-1)
    @alerts = Alert.where(deleted:false)
    @alerts = @alerts.limit(@limit).offset(@offset)
    @count = Alert.count
    @totalPages = count_pages

    #Creating alerts
    @alertType = AlertType.all
    @clients = Client.all
    @alert = Alert.new
    @notificationLevels = NotificationLevel.all

    #Notifications
    @allNotifications = Notification.where("notify_app = true AND triggered = true").order(start_time: :desc).limit(3)
    @triggeredNotifications = Notification.where("notify_app = true AND triggered = true").count
  end

  # GET /alerts/1
  # GET /alerts/1.json
  def show
  end

  # GET /alerts/new
  def new
    @alert = Alert.new
  end

  # GET /alerts/1/edit
  def edit
    @alert = Alert.find(params[:id])
    if @alert.deleted
      flash[:alert_error] = "La alerta que se intentó editar fue eliminada."
      redirect_to action: "index"
    end
    @alerttype = AlertType.all
    @clients = Client.all
    @notificationLevels = NotificationLevel.all

    #Notifications
    @allNotifications = Notification.where("notify_app = true").order(triggered: :desc, start_time: :desc).limit(5)
    @triggeredNotifications = Notification.where("notify_app = true AND triggered = true").count
  end

  # POST /alerts
  # POST /alerts.json
  def create

    if params["alert"][:element] == "engines"
      gateway = Gateway.where("gateway_id = ?", params["alert"][:gateway_id])
      if !gateway.exists?
        flash[:alert_error] = "No existe un gateway con el ID seleccionado"
        redirect_to action: "index"
        return
      end
      gateway = gateway.first
      puts gateway.inspect
      puts "heyyy"
      set_alert_default_variables
      gateway.engines.each do |engine|
        @alert = Alert.new(alert_full_params)
        puts @alert.inspect
        puts "AHOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
        @alert.sign = nil
        @alert.limit = nil
        @alert.alert_type = AlertType.where("column_name = 'status'").first
        @alert.element_id = engine.name
        @alert.deleted = false
        @alert.save
      end
    else
      if params["alert"][:element] == "device"
        if params["alert"][:alert_type_id].to_i.between?(1,3)
          flash[:alert_error] = "Variable incorrecta para el elemento seleccionado."
          redirect_to action: "index"
          return
        end
      end
      if params["alert"][:element] == "hardware"
        if params["alert"][:alert_type_id].to_i.between?(5,7)
          flash[:alert_error] = "Variable incorrecta para el elemento seleccionado."
          redirect_to action: "index"
          return
        end
      end
      set_notify_variables_to_false
      @alert = Alert.new(alert_full_params)

      if @alert.element == "hardware"
        @alert.source = :hardware
      else
        @alert.source = :gateway
      end
    end

    if !@alert.save
      flash[:alert_error] = @alert.errors.full_messages.first
    else
      flash[:alert_success] = "Alerta creada satisfactoriamente"
    end
    redirect_to action: "index"
  end

  # PATCH/PUT /alerts/1
  # PATCH/PUT /alerts/1.json
  def update
    @alert.deleted = true
    @alert.save

    @alert = Alert.new
    element = params["alert"][:element]
    if element == "hardware"
      source = :hardware
    else
      source = :gateway
    end
    @alert.assign_attributes(alert_full_params)
    @alert.source = source
    saved = @alert.save
    if !saved
      flash[:alert_error] = @alert.errors.full_messages.first
      redirect_to action: "edit"
    else
      flash[:alert_success] = "Alerta modificada satisfactoriamente"
      redirect_to action: "index"
    end

  end

  # DELETE /alerts/1
  # DELETE /alerts/1.json
  def destroy
    @alert = Alert.find(params[:id])
    @alert.update(deleted: true)
    Notification.where(alert_id: @alert.id, triggered: true).each do |notification|
      notification.triggered = false
      notification.end_time = DateTime.current
      notification.message = notification.message + "Alerta eliminada."
      notification.save
    end
    flash[:alert_success] = "Alerta eliminada correctamente"
    redirect_to action: "index"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alert
      @alert = Alert.find(params[:id])
    end

  private
    # Only allow a list of trusted parameters through.
    def alert_full_params
      params.require(:alert).permit(:notify_stability, :alert_type_id, :description, :persistence, :limit, :sign, :client_id, :notification_level_id, :element, :gateway_id, :element_id, :notify_app, :notify_slack, :notify_email)
    end

  private
  def set_alert_default_variables
    if params["alert"][:notify_app].nil?
      params["alert"][:notify_app] = false
    end
    if params["alert"][:notify_slack].nil?
      params["alert"][:notify_slack] = false
    end
    if params["alert"][:notify_email].nil?
      params["alert"][:notify_email] = false
    end
  end
  private
    # Counts the total amoung of pages generated
    def count_pages
      if @limit > @count
        return 1
      end
      if @count % @limit != 0
        return @count / @limit + 1
      else
        return @count/@limit
      end
    end
end
