class GatewayStatusController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /gateway_status
  # POST /gateway_status.json
  def create

    #Crea el cliente si no existe
    client = Client.where(client_id: params[:clientId])
    if client.empty?
      client = Client.create(client_id: params[:clientId])
    else
      client = client.take
    end

    #Crea el gateway si no existe
    gateway = Gateway.where(gateway_id: params[:gatewayId])
    if gateway.empty?
      gateway = Gateway.create(gateway_id: params[:gatewayId], client_id: client.id)
    else
      gateway = gateway.take
    end

    #Verifica que hay motores
    if !params[:engines].nil?
      params[:engines].each do |param_engine|

        #Crea el engine si no existe
        engine = Engine.where(name: param_engine[:name], gateway_id: gateway.id)
        if engine.empty?
          engine = Engine.create(name: param_engine[:name], gateway_id: gateway.id)
        else
          engine = engine.take
        end

        #Guarda el estado
        engine_status = EngineStatus.create(status: param_engine[:status] ? 1 : 0, engine_id: engine.id, created_at: params[:updated_at])

        #Verifica alertas
        alert = Alert.where("gateway_id = ? and element_id = ?", gateway.gateway_id, engine.name)
        if alert.exists?
          alert = alert.take
          notification = alert.notifications.where(triggered: true)
          if engine_status.status
            #Si existe una notificacion activa, y el motor esta encendido, se desactiva la alerta
            if notification.exists?
              notification.take.update(triggered: false, end_time: params[:updated_at])
              alert.take.update(triggered: false, persistence_since: nil)
            end
          else
            #Si el motor esta apagado y ya hay una notificacion activa, no hace falta hacer nada
            if notification.exists?
              next
            end
            #El motor esta apagado y se verifica si la alerta exige persistencia
            persistence = alert.persistence
            if persistence.nil? || persistence == 0
              message = create_engine_message(alert.gateway_id, alert.element_id, alert.persistence, alert.client.name)
              Notification.create(triggered: true, alert_id: alert.id, message: message, alert_type_id: alert.alert_type_id, client_id: alert.client_id, gateway_id: alert.gateway_id, notify_app: alert.notify_app, notify_email: alert.notify_email, notify_slack: alert.notify_slack, start_time: params[:updated_at], end_time: nil)
              alert.update(triggered: true)
            else
              #Se verifica cuanto tiempo lleva la condicion de alerta cumpliendose
              if alert.persistence_since.nil?
                alert.persistence_since = params[:updated_at]
              end
              persistence_since = DateTime.parse(alert.persistence_since.to_s)
              current_time = DateTime.parse(params[:updated_at].to_s)
              difference = (current_time - persistence_since)*24*60
              if difference >= alert.persistence
                message = create_engine_message(alert.gateway_id, alert.element_id, alert.persistence, alert.client.name)
                notification = Notification.create(triggered: true, alert_id: alert.id, message: message, alert_type_id: alert.alert_type_id, client_id: alert.client_id, gateway_id: alert.gateway_id, notify_app: alert.notify_app, notify_email: alert.notify_email, notify_slack: alert.notify_slack, start_time: params[:updated_at], end_time: nil)
                alert.update(triggered: true)
              end
            end
          end
        end
      end
    end

    #Verifica que hay dispositivos
    if !params[:devices].nil?
      params[:devices].each do |param_device|

        #Crea el dispositivo si no existe
        device = Device.where(name: param_device[:xbee64], gateway_id: gateway.id)
        if device.empty?
          device = Device.create(name: param_device[:xbee64], gateway_id: gateway.id)
        else
          device = device.take
        end

        #Guarda el estado
        device_status = DeviceStatus.create(status: param_device[:status] ? 1 : 0, dcId: param_device[:dcId], power: param_device[:power] ? 1 : 0, voltage: param_device[:voltage], temperature: param_device[:temperature], device_id: device.id, created_at: params[:updated_at])

        #Verifica que hay sensores
        if !param_device[:sensors].nil?
          param_device[:sensors].each do |param_sensor|

            #Crea el sensor si no existe
            sensor = Sensor.where(sensor_id: param_sensor[:sensorId], device_id: device.id)
            if sensor.empty?
              device = Sensor.create(sensor_id: param_sensor[:sensorId], device_id: device.id)
            end
          end
        end

        #Verifica si hay alertas
        alerts = Alert.where("gateway_id = ? and element = 'device'", gateway.gateway_id)
        if alerts.exists?
          alerts.each do |alert|
            #Consigue el valor al que se le puso alerta
            variable = alert.alert_type.column_name
            value = device_status[variable]
            #Se mira si es un valor booleano para definir si la condicion de alerta se cumple o no
            value_is_boolean = false
            if variable == "status" || variable == "power"
              value_is_boolean = true
              alert_condition = !value
            else
              alert_condition = (alert.sign) ? (value > alert.limit) : (value < alert.limit)
            end
            #Se mira si ya hay notificaciones activas sobre esta variable
            notification = alert.notifications.where(triggered: true)
            if alert_condition
              #Si ya esta activada la alerta, no se hace nada
              if alert.triggered?
                next
              else
                #Se verifica si la alerta exige persistencia
                persistence = alert.persistence
                if persistence.nil? || persistence == 0
                  message = create_device_message(alert.gateway_id, alert.element_id, alert.alert_type.name , alert.sign, alert.limit, alert.persistence, alert.client.name, boolean_variable)
                  Notification.create(triggered: true, alert_id: alert.id, message: message, alert_type_id: alert.alert_type_id, client_id: alert.client_id, gateway_id: alert.gateway_id, notify_app: alert.notify_app, notify_email: alert.notify_email, notify_slack: alert.notify_slack, start_time: params[:updated_at], end_time: nil)
                  alert.update(triggered: true)
                else
                  #Se verifica cuanto tiempo lleva la condicion de alerta cumpliendose
                  if alert.persistence_since.nil?
                    alert.persistence_since = params[:updated_at]
                  end
                  persistence_since = DateTime.parse(alert.persistence_since.to_s)
                  current_time = DateTime.parse(params[:updated_at].to_s)
                  difference = (current_time - persistence_since)*24*60
                  if difference >= alert.persistence
                    message = create_device_message(alert.gateway_id, alert.element_id, alert.alert_type.name, alert.sign, alert.limit, alert.persistence, alert.client.name, boolean_variable)
                    notification = Notification.create(triggered: true, alert_id: alert.id, message: message, alert_type_id: alert.alert_type_id, client_id: alert.client_id, gateway_id: alert.gateway_id, notify_app: alert.notify_app, notify_email: alert.notify_email, notify_slack: alert.notify_slack, start_time: params[:updated_at], end_time: nil)
                    alert.update(triggered: true)
                  end
                end
              end
            else
              #Si hay una notificacion activa y la condicion de alerta ya no se cumple, se desactiva la notificacion y la alerta.
              if notification.exists?
                notification.take.update(triggered: false, end_time: params[:updated_at])
                alert.update(triggered: false)
              end
            end

          end
        end
      end
    end

    render json: gateway.to_json, status: :created
  end

  private
  def create_engine_message(gateway_id, element_id, persistence, client)
      persistence_msg = nil
      if persistence.to_i != 0
        number = (persistence.modulo(1) == 0) ? persistence.to_i : persistence
        minute_or_minutes = (number == 1) ? " minuto" : " minutos"
        persistence_msg = " por más de #{number} #{minute_or_minutes}"
      end
      message = "El gateway con ID #{gateway_id} del cliente #{client} ha gatillado una alerta. El motor #{element_id} se ha apagado#{persistence_msg}."
      return message
  end

  private
  def create_device_message(gateway_id, element_id, alert_type, sign, limit, persistence, client, boolean_variable)
      persistence_msg = "está "
      if persistence.to_i != 0
        number = (persistence.modulo(1) == 0) ? persistence.to_i : persistence
        minute_or_minutes = number == 1 ? " minuto" : " minutos"
        persistence_msg = "lleva #{number} #{minute_or_minutes}"
      end
      if !boolean_variable
        greater_or_less = (sign) ? "por encima" : "por debajo"
        degree_or_percent = (alert_type == "Temperatura") ? "grados" : "porciento"
        message = "El dispositivo #{element_id} del gateway con ID #{gateway_id} del cliente #{client} ha gatillado una alerta. #{alert_type} #{persistence_msg} #{greater_or_less} de #{limit} #{degree_or_percent}."
      else
        status_or_power = (alert_type == :status) ? "apagado" : "sin energizar"
        message = "El dispositivo #{element_id} del gateway con ID #{gateway_id} del cliente #{client} ha gatillado una alerta. El dispositivo #{persistence_msg} #{status_or_power}."
      return message
    end
  end
end
