require 'test_helper'

class GatewayStatusHistoryControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gateway_status_history = gateway_status_history(:one)
  end

  test "should get index" do
    get gateway_status_history_index_url
    assert_response :success
  end

  test "should get new" do
    get new_gateway_status_history_url
    assert_response :success
  end

  test "should create gateway_status_history" do
    assert_difference('GatewayStatusHistory.count') do
      post gateway_status_history_index_url, params: { gateway_status_history: { json_text: @gateway_status_history.json_text } }
    end

    assert_redirected_to gateway_status_history_url(GatewayStatusHistory.last)
  end

  test "should show gateway_status_history" do
    get gateway_status_history_url(@gateway_status_history)
    assert_response :success
  end

  test "should get edit" do
    get edit_gateway_status_history_url(@gateway_status_history)
    assert_response :success
  end

  test "should update gateway_status_history" do
    patch gateway_status_history_url(@gateway_status_history), params: { gateway_status_history: { json_text: @gateway_status_history.json_text } }
    assert_redirected_to gateway_status_history_url(@gateway_status_history)
  end

  test "should destroy gateway_status_history" do
    assert_difference('GatewayStatusHistory.count', -1) do
      delete gateway_status_history_url(@gateway_status_history)
    end

    assert_redirected_to gateway_status_history_index_url
  end
end
