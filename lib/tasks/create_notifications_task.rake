task :create_fake_notifications => [:environment] do

100.times do |i|
  triggered = [true, false].sample
  start_time = Date.today - 5 - rand(60)
  end_time = nil
  if !triggered
  end_time = start_time + rand(6)
  end
  Notification.create(triggered: triggered, alert_id: 999, message: "test", alert_type_id: rand(1..4), persistence: rand(3), limit: rand(90), sign: [true, false].sample, client_id: rand(1..2), source: [:gateway, :hardware].sample, element: ["motors", "devices"].sample, gateway_id: rand(1...999),element_id: rand(1...999), notification_level_id: rand(1..3), notify_app: [true, false].sample, notify_email: false, notify_slack: [true, false].sample, start_time: start_time, end_time: end_time)
end

end
