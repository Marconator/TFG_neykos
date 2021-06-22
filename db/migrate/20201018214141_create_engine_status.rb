class CreateEngineStatus < ActiveRecord::Migration[6.0]
  def change
    create_table :engine_status do |t|
      t.integer :status
      t.references :engine, foreign_key: true
      t.datetime :created_at
    end
  end
end
