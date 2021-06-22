class CreateGateways < ActiveRecord::Migration[6.0]
  def change
    create_table :gateways do |t|
      t.string :gateway_id
      t.references :client, foreign_key: true
    end
  end
end
