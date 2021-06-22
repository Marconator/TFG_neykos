require "application_system_test_case"

class GatewayStatusesTest < ApplicationSystemTestCase
  setup do
    @gateway_status = gateway_status(:one)
  end

  test "visiting the index" do
    visit gateway_status_url
    assert_selector "h1", text: "Gateway Statuses"
  end

  test "creating a Gateway status" do
    visit gateway_status_url
    click_on "New Gateway Status"

    fill_in "Gateway", with: @gateway_status.gateway_id
    fill_in "Updated at", with: @gateway_status.updated_at
    click_on "Create Gateway status"

    assert_text "Gateway status was successfully created"
    click_on "Back"
  end

  test "updating a Gateway status" do
    visit gateway_status_url
    click_on "Edit", match: :first

    fill_in "Gateway", with: @gateway_status.gateway_id
    fill_in "Updated at", with: @gateway_status.updated_at
    click_on "Update Gateway status"

    assert_text "Gateway status was successfully updated"
    click_on "Back"
  end

  test "destroying a Gateway status" do
    visit gateway_status_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Gateway status was successfully destroyed"
  end
end
