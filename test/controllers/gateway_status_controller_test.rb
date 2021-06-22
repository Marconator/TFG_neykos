require 'test_helper'

class GatewayStatusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gateway_status = gateway_status(:one)
    @device = devices(:one)
    @motor = motors(:one)
    @sensor = sensors(:one)
  end

  test "should get index" do
    get gateway_status_index_url
    assert_response :success
  end

  test "should get new" do
    get new_gateway_status_url
    assert_response :success
  end

  test "should create gateway_status" do
    assert_difference('GatewayStatus.count') do
      post gateway_status_index_url, params: { gateway_status: { gateway_id: @gateway_status.gateway_id, updated_at: @gateway_status.updated_at },
                                               devices: [gateway_id: @gateway_status.gateway_id, updated_at: @gateway_status.updated_at,
                                                          sensors: [sensor_id: @sensor.sensor_id, device_id: @sensor.device_id]],
                                               motors: [name: @motor.name, status: @motor.status, gateway_status_id: @motor.gateway_status_id]
                                             }
    end

    assert_response(:created)
  end

  test "should show gateway_status" do
    get gateway_status_url(@gateway_status)
    assert_response :success
  end

  test "should get edit" do
    get edit_gateway_status_url(@gateway_status)
    assert_response :success
  end

  test "should update gateway_status" do
    patch gateway_status_url(@gateway_status), params: { gateway_status: { gateway_id: @gateway_status.gateway_id, updated_at: @gateway_status.updated_at } }
    assert_redirected_to gateway_status_url(@gateway_status)
  end

  test "should destroy gateway_status" do
    assert_difference('GatewayStatus.count', -1) do
      delete gateway_status_url(@gateway_status)
    end

    assert_redirected_to gateway_status_index_url
  end
end
