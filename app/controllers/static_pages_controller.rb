# frozen_string_literal: true

class StaticPagesController < ApplicationController
  # The folloiwng line is to deactivate Pundit authorize/policy verification
  # Use it when activating :verify_authorized in application_controller.rb
  # when developping Pundit policies
  # skip_after_action :verify_authorized

  def home; end

  def about_us; end
end
