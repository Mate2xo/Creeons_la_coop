# frozen_string_literal: true

# Ressource for the members to get products from (vegetables...), and are managed by the 'management/supply' team
class ProductorsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_authorized_productor, only: %i[show edit update destroy]

  def index
    @productors = Productor.includes :address, :avatar_attachment
  end

  def new
    @productor = authorize Productor.new

    # address form generator
    @productor.build_address
  end

  def create
    @productor = authorize Productor.new(permitted_params)
    if @productor.save
      flash[:notice] = translate "activerecord.notices.messages.record_created"
      render :show
    else
      flash[:error] = translate "activerecord.errors.messages.creation_fail"
      render :new
    end
  end

  def show; end

  def edit
    @productor.build_address if @productor.address.nil?
  end

  def update
    if @productor.update(permitted_params)
      flash[:notice] = translate "activerecord.notices.messages.update_success"
      render :show
    else
      flash[:error] = translate "activerecord.errors.messages.update_fail"
      render :edit
    end
  end

  def destroy
    if @productor.destroy
      flash[:notice] = translate "activerecord.notices.messages.record_destroyed"
    else
      flash[:error] = translate "activerecord.errors.messages.destroy_fail"
    end
    redirect_to productors_path
  end

  private

  def permitted_params
    params.require(:productor).permit(:name, :description, :local,
                                      :phone_number, :website_url, :avatar,
                                      catalogs: [],
                                      address_attributes: [
                                        :id, :postal_code, :city, :street_name_1,
                                        :street_name_2, coordinates: []
                                      ])
  end

  def set_authorized_productor
    @productor = authorize Productor.find(params[:id])
  end
end
