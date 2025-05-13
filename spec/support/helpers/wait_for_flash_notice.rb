module WaitForFlashNotice
  def wait_for_flash_messages
    expect(page).to have_css('div#flash_messages')
  end

  def wait_for_success_flash
    expect(page).to have_css('div#flash_notice.alert-success')
  end

  def wait_for_warning_flash
    expect(page).to have_css('div#flash_alert.alert-warning')
  end

  def wait_for_danger_flash
    expect(page).to have_css('div#flash_error.alert-danger')
  end
end
