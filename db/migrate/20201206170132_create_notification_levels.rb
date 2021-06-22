class CreateNotificationLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_levels do |t|
      t.string :name
      t.string :description
    end
  end
end
