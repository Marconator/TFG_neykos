# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  
  def notification_email
    NotificationMailer.with(client_id: 1, message: "Hola mundo").notification_email
  end
end
