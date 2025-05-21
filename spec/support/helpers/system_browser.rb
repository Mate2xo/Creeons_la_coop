# frozen_string_literal: true

module SystemBrowser
  def use_headless_javascript_browser
    driven_by(:selenium_headless)
  end

  def use_fast_non_js_browser
    driven_by(:rack_test)
  end
end
