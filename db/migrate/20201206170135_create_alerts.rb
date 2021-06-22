class CreateAlerts < ActiveRecord::Migration[6.0]
  def change
    create_table :alerts do |t|
      t.boolean :triggered, default: false
      t.boolean :notify_stability
      t.references :alert_type, foreign_key: true
      t.text :description
      t.float :persistence
      t.float :limit
      t.boolean :sign
      t.references :client, foreign_key: true
      t.references :notification_level, foreign_key: true
      t.string :source
      t.string :element
      t.string :element_id
      t.references :gateway, foreign_key: true
      t.datetime :persistence_since
      t.boolean :notify_app
      t.boolean :notify_email
      t.boolean :notify_slack
      t.boolean :deleted
      t.timestamps
    end
  end
end
