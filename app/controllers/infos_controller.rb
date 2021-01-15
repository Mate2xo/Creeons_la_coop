# frozen_string_literal: true

# Newsfeeds.
class InfosController < ApplicationController
  before_action :authenticate_member!

  def index
    @infos = Info.all.order(updated_at: :desc)
  end

  def show
    @info = Info.find(params[:id])
  end

  private

  def permitted_params
    params.require(:info).permit(:title, :content)
  end
end
