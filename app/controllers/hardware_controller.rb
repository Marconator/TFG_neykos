class HardwareController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /hardware
  # GET /hardware.json
  def index
    hardware = Hardware.all
    render json: hardware.to_json(:except => [:id])
  end

  # POST /hardware
  # POST /hardware.json
  def create

    #Se mira si existe el gateway con ese ID
    gateway_id = Gateway.where("gateway_id = ?", params[:gatewayId])
    if gateway.exists?
      gateway_id = gateway.take.id
    else
      gateway_id = nil
    end

    #Se guardan los datos recibidos
    hardware = Hardware.create(gateway_id: gateway_id, hardware_id: params[:gatewayId], cpu_percent: params[:cpu][:percent], memory_available: params[:memory][:available], memory_total: params[:memory][:total], memory_percent:  params[:memory][:percent], disk_free: params[:disk][:free], disk_total: params[:disk][:total], disk_percent: params[:disk][:percent], temperature: params[:temperature][:value], updated_at: params[:updated_at])

    #Se mira si existen alertas para este hardware
    alerts = Alert.where("element = ? AND element_id = ?", "hardware", hardware.hardware_id)
    if alerts.present?
      alerts.each do |alert|
          #Se obtiene el valor que esta monitorizando la alerta
          alert_type = alert.alert_type_id.column_name
          alert_type_name = alert.alert_type.name
          hardware_value = hardware[alert_type]
          persistence = alert.persistence
          alert_condition = (alert.sign) ? (hardware_value > alert.limit) : (hardware_value < alert.limit)

          #Se mira si se cumple la condicion de alerta
          if alert_condition
            #Si ya la alerta esta activada, no se hace nada
            if alert.triggered
              next
            end
            #Se mira si la alerta exige persistencia
            if persistence.nil? || persistence == 0
              message = create_trigger_message(alert.element_id, alert_type_name, alert.sign, alert.limit, alert.persistence, hardware.updated_at, alert.client.name)
              notification = Notification.create(triggered: true, alert_id: alert.id, message: message, alert_type_id: alert.alert_type_id, client_id: alert.client_id, gateway_id: alert.gateway_id, notify_app: alert.notify_app, notify_email: alert.notify_email, notify_slack: alert.notify_slack, start_time: params[:updated_at], end_time: nil)
              alert.update(triggered:true)
            else
              #Se mira si la condicion lleva cumpliendose mas que la persistencia exigida
              if alert.persistence_since.nil?
                alert.persistence_since = hardware.updated_at
              end
              persistence_since = DateTime.parse(alert.persistence_since.to_s)
              current_time = DateTime.parse(hardware.updated_at.to_s)
              difference = (current_time - persistence_since)*24*60
              if difference >= alert.persistence
                message = create_trigger_message(alert.element_id, alert_type_name, alert.sign, alert.limit, alert.persistence, hardware.updated_at, alert.client.name)
                notification = Notification.create(triggered: true, alert_id: alert.id, message: message, alert_type_id: alert.alert_type_id, client_id: alert.client_id, gateway_id: alert.gateway_id, notify_app: alert.notify_app, notify_email: alert.notify_email, notify_slack: alert.notify_slack, start_time: params[:updated_at], end_time: nil)
                alert.update(triggered:true)
              end
            end
          else
            #Si no se cumple la condicion de alerta y la alerta esta encendida, se apaga
            if alert.triggered
              alert.update(triggered: false, persistence_since: nil)
              notifications = alert.notifications.where(triggered: true)
              if notifications.present?
                notification = notifications.take
                notification.update(triggered: false, end_time: hardware.updated_at)
              end
            end
          end

      end

    end

    render json: hardware.to_json, status: :ok
  end

    private
    def create_trigger_message(element_id, alert_type, sign, limit, persistence, time, client)
      persistence_msg = nil
      if persistence.to_i != 0
        number = (persistence.modulo(1) == 0) ? persistence.to_i : persistence
        minute_or_minutes = (number == 1) ? " minuto" : " minutos"
        persistence_msg = " lleva #{number} #{minute_or_minutes}"
      end
      encima_o_debajo = (sign) ? "encima" : "debajo"
      porciento_o_grados = (alert_type == "Temperatura") ? "grados" : "porciento"
      message = "El hardware con ID #{element_id} del cliente #{client} ha gatillado una alerta. #{alert_type} #{persistence_msg} por #{encima_o_debajo} de #{limit} #{porciento_o_grados}."
      return message
    end

end
