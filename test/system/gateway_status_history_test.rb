require "application_system_test_case"

class GatewayStatusHistoriesTest < ApplicationSystemTestCase
  setup do
    @gateway_status_history = gateway_status_history(:one)
  end

  test "visiting the index" do
    visit gateway_status_history_url
    assert_selector "h1", text: "Gateway Status Histories"
  end

  test "creating a Gateway status history" do
    visit gateway_status_history_url
    click_on "New Gateway Status History"

    fill_in "Json text", with: @gateway_status_history.json_text
    click_on "Create Gateway status history"

    assert_text "Gateway status history was successfully created"
    click_on "Back"
  end

  test "updating a Gateway status history" do
    visit gateway_status_history_url
    click_on "Edit", match: :first

    fill_in "Json text", with: @gateway_status_history.json_text
    click_on "Update Gateway status history"

    assert_text "Gateway status history was successfully updated"
    click_on "Back"
  end

  test "destroying a Gateway status history" do
    visit gateway_status_history_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Gateway status history was successfully destroyed"
  end
end
