require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  setup do
    @gateway_status = GatewayStatus.create(id: 3, gateway_id: 10, updated_at: "hora")
    @device = Device.create(id: 3, device_id: "ABC123", gateway_status_id: 3)
    @sensor =  Sensor.create(sensor_id: 500, device_id: 3)
    @sensor2 =  Sensor.create(sensor_id: 501, device_id: 3)
  end

  test "sensor dependency" do
    assert_difference('Sensor.count', -2) do
      @device.destroy
    end
  end


end
