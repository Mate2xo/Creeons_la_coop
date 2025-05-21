# frozen_string_literal: true

RSpec::Matchers.define :have_flash do |type, options|
  match do |page|
    color = {notice: :success, alert: :warning, error: :danger}[type]
    expect(page).to have_css "div#flash_#{type}.alert-#{color}", **options
  end
end
