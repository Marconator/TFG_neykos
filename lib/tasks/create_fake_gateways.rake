task :create_fake_gateways => [:environment] do

  if Gateway.all.empty?
    Gateway.create(gateway_id: 1, client_id: 1)
    Gateway.create(gateway_id: 2, client_id: 1)
    Gateway.create(gateway_id: 3, client_id: 2)
    Gateway.create(gateway_id: 4, client_id: 2)
  end
  puts "Gateways falsos creados"
  time = DateTime.now-7
  if Engine.all.empty?
    Gateway.all.each do |g|
      Engine.create(name: "pms:status:hardware", gateway_id: g.id)
      Engine.create(name: "pms:status:gateway", gateway_id: g.id)
      Engine.create(name: "pms:status:processor", gateway_id: g.id)
      Engine.create(name: "pms:status:connectivity", gateway_id: g.id)
      Engine.create(name: "pms:status:xbee", gateway_id: g.id)
      Engine.create(name: "pms:status:configuration", gateway_id: g.id)
      10080.times do |m|
        bool1 = [0, 1, 1, 1].sample
        bool2 = [0, 1, 1, 1].sample
        datetime = time+(m/1440.to_d)
        EngineStatus.create(status: bool1, engine_id: 1, created_at: datetime)
        EngineStatus.create(status: bool2, engine_id: 2, created_at: datetime)
        EngineStatus.create(status: bool1 && bool2, engine_id: 3, created_at: datetime)
        EngineStatus.create(status: bool1 || bool2, engine_id: 4, created_at: datetime)
        EngineStatus.create(status: !(bool1 && bool2), engine_id: 5, created_at: datetime)
        EngineStatus.create(status: !(bool2 || bool1), engine_id: 6, created_at: datetime)
      end
      puts "Motores del gateway #{g.id} completo"
    end
  end

  if Device.all.empty?
    Gateway.all.each do |g|
      d = Device.create(name: "0013A20041641E3#{g.id}", gateway_id: g.id)
      10080.times do |m|
        bool = [0, 1].sample
        datetime = time+(m/1440.to_d)
        DeviceStatus.create(status: bool, power: bool, voltage: rand(15), temperature: rand(10..50), device_id: d.id, created_at: datetime)
      end
      puts "Dispositivo del gateway #{g.id} completo"
    end
  end

  if Hardware.all.empty?
    10080.times do |m|
      m_a = rand(50..100)
      d_t = rand(50..100)
      datetime = time+(m/1440.to_d)
      Hardware.create(gateway_id: 1, hardware_id: "147", cpu_percent: rand(50), memory_available: m_a, memory_total: 100, memory_percent: m_a , disk_free: d_t, disk_total: 100, disk_percent: d_t, temperature: rand(), updated_at: datetime)
      Hardware.create(gateway_id: 2, hardware_id: "147", cpu_percent: rand(50), memory_available: m_a, memory_total: 100, memory_percent: m_a , disk_free: d_t, disk_total: 100, disk_percent: d_t, temperature: rand(), updated_at: datetime)
      Hardware.create(gateway_id: 3, hardware_id: "147", cpu_percent: rand(50), memory_available: m_a, memory_total: 100, memory_percent: m_a , disk_free: d_t, disk_total: 100, disk_percent: d_t, temperature: rand(), updated_at: datetime)
      Hardware.create(gateway_id: 4, hardware_id: "147", cpu_percent: rand(50), memory_available: m_a, memory_total: 100, memory_percent: m_a , disk_free: d_t, disk_total: 100, disk_percent: d_t, temperature: rand(), updated_at: datetime)
    end
    puts "Hardware listo"
  end

end
