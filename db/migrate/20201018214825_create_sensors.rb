class CreateSensors < ActiveRecord::Migration[6.0]
  def change
    create_table :sensors do |t|
      t.string :sensor_id
      t.references :device, foreign_key: true
    end
  end
end
