require "application_system_test_case"

class AlertsTest < ApplicationSystemTestCase
  setup do
    @alert = alerts(:one)
  end

  test "visiting the index" do
    visit alerts_url
    assert_selector "h1", text: "Alerts"
  end

  test "creating a Alert" do
    visit alerts_url
    click_on "New Alert"

    check "Active" if @alert.active
    fill_in "Client", with: @alert.client
    fill_in "Description", with: @alert.description
    fill_in "Device", with: @alert.device
    check "Fired" if @alert.fired
    fill_in "Limit", with: @alert.limit
    fill_in "Persistence", with: @alert.persistence
    fill_in "Sign", with: @alert.sign
    fill_in "Time", with: @alert.time
    fill_in "Type", with: @alert.type
    click_on "Create Alert"

    assert_text "Alert was successfully created"
    click_on "Back"
  end

  test "updating a Alert" do
    visit alerts_url
    click_on "Edit", match: :first

    check "Active" if @alert.active
    fill_in "Client", with: @alert.client
    fill_in "Description", with: @alert.description
    fill_in "Device", with: @alert.device
    check "Fired" if @alert.fired
    fill_in "Limit", with: @alert.limit
    fill_in "Persistence", with: @alert.persistence
    fill_in "Sign", with: @alert.sign
    fill_in "Time", with: @alert.time
    fill_in "Type", with: @alert.type
    click_on "Update Alert"

    assert_text "Alert was successfully updated"
    click_on "Back"
  end

  test "destroying a Alert" do
    visit alerts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Alert was successfully destroyed"
  end
end
