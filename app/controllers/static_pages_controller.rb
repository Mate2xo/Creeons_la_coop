# frozen_string_literal: true

class StaticPagesController < ApplicationController
  # The folloiwng line is to deactivate Punidt authorize/policy verification
  # skip_after_action :verify_authorized

  def home; end

  def ensavoirplus; end
end
