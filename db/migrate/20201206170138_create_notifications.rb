class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.boolean :triggered
      t.boolean :notify_app
      t.boolean :notify_email
      t.boolean :notify_slack
      t.integer :alert_id
      t.string :message
      t.string :email_message_id
      t.references :client, foreign_key: true
      t.references :notification_level, foreign_key: true
      t.references :gateway, foreign_key: true
      t.references :alert_type, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
    end
  end
end
