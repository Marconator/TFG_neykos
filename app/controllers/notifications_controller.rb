class NotificationsController < ApplicationController
before_action :authenticate_user!

  # GET /notifications
  def index
    #Filter
    @notificationLevels = NotificationLevel.all
    @notificationVariables = AlertType.all
    @clients = Client.all

    if params[:filter].present?
    @filterLevel = params[:filter][:level]
    @filterVariable = params[:filter][:variable]
    @filterClient = params[:filter][:client]
    @filterGatewayId = params[:filter][:gateway_id]
    @filterStartFrom = params[:filter][:start_time_from]
    end

    @notifications = Notification

    if @filterLevel.present?
      @notifications = @notifications.where("notification_level_id = ?", @filterLevel)
    end
    if @filterVariable.present?
      @notifications = @notifications.where("alert_type_id = ?", @filterVariable)
    end
    if @filterClient.present?
      @notifications = @notifications.where("client_id = ?", @filterClient)
    end
    if @filterGatewayId.present?
      @notifications = @notifications.where("gateway_id = ?", @filterGatewayId)
    end
    if @filterStartFrom.present?
      start_time = Date.today
      end_time = start_time+1
      case @filterStartFrom
      when "2" #AYER
        start_time = start_time-1
        end_time = start_time+1
      when "3" #ESTA SEMANA
        start_time = start_time-start_time.wday+1 #lunes de esta semana
      when "4" #SEMANA PASADA
        start_time = start_time-start_time.wday-6 #lunes de la semana pasada
        end_time = start_time+7
      when "5" #ESTE MES
        start_time = start_time-start_time.mday+1 #primer dia de este mes
        start_time = start_time-start_time.mday+1 #primer dia del mes anterior
      when "6" #MES PASADO
        start_time = start_time-start_time.mday #ultimo dia del mes anterior
        end_time = start_time
        start_time = start_time-start_time.mday+1 #primer dia del mes anterior
      end
      @notifications = @notifications.where("start_time >= ?", start_time)
      @notifications = @notifications.where("start_time < ?", end_time)
      @notifications = @notifications.order('start_time ASC')
    else
      @notifications = @notifications.order('id DESC')
    end


    #Paging
    @page = (params[:page].presence != nil) ? params[:page].to_i : 1
    @limit = 20
    @offset = @limit*(@page-1)
    @count = @notifications.count
    @notifications = @notifications.order('id DESC').limit(@limit).offset(@offset)
    @totalPages = count_pages

    #Notifications
    @allNotifications = Notification.where("notify_app = true AND triggered = true").order(start_time: :desc).limit(3)
    @triggeredNotifications = Notification.where("notify_app = true AND triggered = true").count
  end

  # GET /notifications/1
  def show
    @notification = Notification.find(params[:id])
    @notificationLevels = NotificationLevel.all

    #Notifications
    @allNotifications = Notification.where("notify_app = true AND triggered = true").order(start_time: :desc).limit(3)
    @triggeredNotifications = Notification.where("notify_app = true AND triggered = true").count
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.json
  def destroy
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
