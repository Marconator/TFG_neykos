# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

if AlertType.all.empty?
AlertType.create(name: "Uso del CPU", column_name: :cpu_percent)
AlertType.create(name: "Uso de memoria", column_name: :memory_percent)
AlertType.create(name: "Uso del disco", column_name: :disk_percent)
AlertType.create(name: "Temperatura", column_name: :temperature)
AlertType.create(name: "Estado", column_name: :status)
AlertType.create(name: "Energía", column_name: :power)
AlertType.create(name: "Voltaje", column_name: :voltage)
puts "Tipos de alerta creados"

NotificationLevel.create(name: "Nivel 1", description: "Información")
NotificationLevel.create(name: "Nivel 2", description: "Precaución")
NotificationLevel.create(name: "Nivel 3", description: "Error fatal")
puts "Niveles de notificacion creados"


Client.create(name: "Bonlac")
Client.create(name: "LDC")
puts "Clientes de ejemplo creados"
end
