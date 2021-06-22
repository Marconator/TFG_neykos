class GraphsController < ApplicationController
before_action :authenticate_user!

  def index
    #Notifications
    @allNotifications = Notification.where("notify_app = true AND triggered = true").order(start_time: :desc).limit(3)
    @triggeredNotifications = Notification.where("notify_app = true AND triggered = true").count

    #Graphs
    parameters = params[:graph]
     if parameters.present?
       @client = parameters[:client]
       @gateway = parameters[:gateway]
       @element = parameters[:element]
       @device = parameters[:device]
       @time_range = parameters[:time_range]

       start_time = Date.today
       end_time = start_time+1
       case @time_range
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

       case @element
       #Engines
       when "1"
         gateway = Gateway.find(@gateway)
         @engines = gateway.engines
         @data = {}
         @engines.each do |engine|
           engine_hash = {}
           engine_status_raw_data = engine.engine_status.where("created_at >= ?", start_time).where("created_at < ?", end_time).order('created_at ASC').limit(144)
           engine_status_raw_data.each do |engine_status|
             engine_hash[engine_status.created_at] = engine_status.status
           end
           @data[engine.id] = engine_hash
         end
       #Device
       when "2"
         device_satatus_raw_data = DeviceStatus.where(gateway_id: gateway).where("created_at >= ?", start_time).where("created_at < ?", end_time).order('created_at ASC').as_json
       #Hardware
       when "3"
         @data = Hardware.where(gateway_id: gateway).where("updated_at >= ?", start_time).where("updated_at < ?", end_time).order('updated_at ASC').as_json
       end

     end
  end

end
