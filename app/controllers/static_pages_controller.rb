# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home; end

  def dashboard
    redirect_to new_member_session_path unless member_signed_in?
    @infos = Info.all
    @missions = Mission.all
  end

  def ensavoirplus; end
end
