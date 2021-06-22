class NotificationMailer < ApplicationMailer
  default from: 'notificaciones@neykos.com'

  def stabilization_email
    @client = Client.find(params[:client_id])
    @message = "La alerta anterior se ha estabilizado."
    mail(to: @client.emails.pluck(:email), subject: 'RE: Notificación de alerta', references: "<#{params[:message_id]}>")
  end

  def notification_email
    @client = Client.find(params[:client_id])
    @message = params[:message]
    mail(to: @client.emails.pluck(:email), subject: 'Notificación de alerta')
  end
end
