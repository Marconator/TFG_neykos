class Notification < ApplicationRecord
  belongs_to :alert
  belongs_to :notification_level
  belongs_to :client
  belongs_to :alert_type
  after_create :send_notification_email
  after_save :send_stabilization_email


private
  def send_notification_email
    if self.notify_email
      email = NotificationMailer.with(client_id: self.client_id, message: self.message).notification_email.deliver_later
      self.message_id = email.message_id
      self.save
    end
  end

private
  def send_stabilization_email
    if (self.notify_email && self.notify_stability && !self.alert.deleted )
      NotificationMailer.with(client_id: self.client_id, message_id: self.message_id).stabilization_email.deliver_later
    end
  end

end
