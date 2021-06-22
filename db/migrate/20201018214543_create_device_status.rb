class CreateDeviceStatus < ActiveRecord::Migration[6.0]
  def change
    create_table :device_status do |t|
      t.integer :status
      t.integer :power
      t.float :voltage
      t.float :temperature
      t.integer :dcId
      t.references :device, foreign_key: true
      t.datetime :created_at
    end
  end
end
