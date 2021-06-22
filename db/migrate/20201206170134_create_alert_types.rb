class CreateAlertTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :alert_types do |t|
      t.string :name
      t.string :column_name
    end
  end
end
