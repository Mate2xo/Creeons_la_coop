module SystemBrowser
  def use_headless_javascript_browser
    driven_by(:selenium_headless)
  end

  def use_fast_non_js_browser
    driven_by(:rack_test)
  end

  def wait_for_flash_messages
    expect(page).to have_css('div#flash_messages')
  end

  def wait_flash(color)
    type = {success: :notice, warning: :alert, danger: :error}[color]
    expect(page).to have_css("div#flash_#{type}.alert-#{color}")
  end
end
