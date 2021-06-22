class CreateHardware < ActiveRecord::Migration[6.0]
  def change
    create_table :hardware do |t|
      t.string :hardware_id
      t.references :gateway
      t.float :cpu_percent
      t.float :memory_available
      t.float :memory_total
      t.float :memory_percent
      t.float :disk_free
      t.float :disk_total
      t.float :disk_percent
      t.float :temperature
      t.datetime :updated_at
    end
  end
end
