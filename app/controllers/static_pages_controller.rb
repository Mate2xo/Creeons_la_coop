class StaticPagesController < ApplicationController
  def home
  end

  def dashboard
    redirect_to new_member_session_path unless member_signed_in?
  end
end
