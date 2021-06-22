require 'test_helper'

class HardwareControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hardware = hardware(:one)
  end

  test "should get index" do
    get hardware_index_url
    assert_response :success
  end

  test "should get new" do
    get new_hardware_url
    assert_response :success
  end

  test "should create hardware" do
    assert_difference('Hardware.count') do
      post hardware_index_url, params: { hardware: { cpu_percent: @hardware.cpu_percent, disk_free: @hardware.disk_free, disk_percent: @hardware.disk_percent, disk_total: @hardware.disk_total, hardware_id: @hardware.hardware_id, memory_available: @hardware.memory_available, memory_percent: @hardware.memory_percent, memory_total: @hardware.memory_total, temperature: @hardware.temperature, updated_at: @hardware.updated_at } }
    end

    assert_redirected_to hardware_url(Hardware.last)
  end

  test "should show hardware" do
    get hardware_url(@hardware)
    assert_response :success
  end

  test "should get edit" do
    get edit_hardware_url(@hardware)
    assert_response :success
  end

  test "should update hardware" do
    patch hardware_url(@hardware), params: { hardware: { cpu_percent: @hardware.cpu_percent, disk_free: @hardware.disk_free, disk_percent: @hardware.disk_percent, disk_total: @hardware.disk_total, hardware_id: @hardware.hardware_id, memory_available: @hardware.memory_available, memory_percent: @hardware.memory_percent, memory_total: @hardware.memory_total, temperature: @hardware.temperature, updated_at: @hardware.updated_at } }
    assert_redirected_to hardware_url(@hardware)
  end

  test "should destroy hardware" do
    assert_difference('Hardware.count', -1) do
      delete hardware_url(@hardware)
    end

    assert_redirected_to hardware_index_url
  end
end
