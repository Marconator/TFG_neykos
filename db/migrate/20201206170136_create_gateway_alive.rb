class CreateGatewayAlive < ActiveRecord::Migration[6.0]
  def change
    create_table :gateway_alive do |t|
      t.string :gateway_id
      t.datetime :created_at
    end
  end
end
