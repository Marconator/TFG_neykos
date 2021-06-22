require "application_system_test_case"

class HardwareTest < ApplicationSystemTestCase
  setup do
    @hardware = hardware(:one)
  end

  test "visiting the index" do
    visit hardware_url
    assert_selector "h1", text: "Hardware"
  end

  test "creating a Hardware" do
    visit hardware_url
    click_on "New Hardware"

    fill_in "Cpu percent", with: @hardware.cpu_percent
    fill_in "Disk free", with: @hardware.disk_free
    fill_in "Disk percent", with: @hardware.disk_percent
    fill_in "Disk total", with: @hardware.disk_total
    fill_in "Hardware", with: @hardware.hardware_id
    fill_in "Memory available", with: @hardware.memory_available
    fill_in "Memory percent", with: @hardware.memory_percent
    fill_in "Memory total", with: @hardware.memory_total
    fill_in "Temperature", with: @hardware.temperature
    fill_in "Updated at", with: @hardware.updated_at
    click_on "Create Hardware"

    assert_text "Hardware was successfully created"
    click_on "Back"
  end

  test "updating a Hardware" do
    visit hardware_url
    click_on "Edit", match: :first

    fill_in "Cpu percent", with: @hardware.cpu_percent
    fill_in "Disk free", with: @hardware.disk_free
    fill_in "Disk percent", with: @hardware.disk_percent
    fill_in "Disk total", with: @hardware.disk_total
    fill_in "Hardware", with: @hardware.hardware_id
    fill_in "Memory available", with: @hardware.memory_available
    fill_in "Memory percent", with: @hardware.memory_percent
    fill_in "Memory total", with: @hardware.memory_total
    fill_in "Temperature", with: @hardware.temperature
    fill_in "Updated at", with: @hardware.updated_at
    click_on "Update Hardware"

    assert_text "Hardware was successfully updated"
    click_on "Back"
  end

  test "destroying a Hardware" do
    visit hardware_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hardware was successfully destroyed"
  end
end
