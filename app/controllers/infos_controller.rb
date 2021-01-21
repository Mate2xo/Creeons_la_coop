# frozen_string_literal: true

# Newsfeeds.
class InfosController < ApplicationController
  def index
    @infos = if member_signed_in?
               Info.all.order(updated_at: :desc)
             else
               Info.where(published: true).order(updated_at: :desc)
             end
  end

  def show
    @info = Info.find(params[:id])
  end
end
