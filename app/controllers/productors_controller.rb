# frozen_string_literal: true

# Ressource for the members to get products from (vegetables...), and are managed by the 'Aprovisionnement/Commande' team
# Can be CRUDed by an admin, R by members
# Available methods: #address, #name, #description, #managers
class ProductorsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_productor, only: %i[show edit update destroy]

  def index
    @productors = Productor.all
  end

  def new
    @productor = Productor.new
    authorize @productor

    # address form generator
    @productor_address = @productor.build_address
  end

  def create
    @productor = Productor.new(permitted_params)
    authorize @productor
    if @productor.save
      flash[:notice] = "Le producteur a bien été créé"
      redirect_to @productor
    else
      flash[:error] = "Une erreur est survenue, veuillez recommencer l'opération"
    end
  end

  def show
    authorize @productor
  end

  def edit
    authorize @productor
    # address form generator
    @productor_address = @productor.address || @productor.build_address
  end

  def update
    authorize @productor
    if @productor.update_attributes(permitted_params)
      flash[:notice] = "Le producteur a bien été mis à jour"
      redirect_to @productor
    else
      flash[:error] = "Une erreur est survenue, veuillez recommencer l'opération"
      redirect_to edit_productor_path(@productor.id)
    end
  end

  def destroy
    authorize @productor
    if @productor.destroy
      flash[:notice] = "Le producteur a été supprimé"
    else
      flash[:error] = "Opération échouée, une erreur est survenue"
    end
    redirect_to productors_path
  end

  private

  def permitted_params
    params.require(:productor).permit(:name, :description, :phone_number, :website_url, :avatar, catalogs: [], address_attributes: %i[id postal_code city street_name_1 street_name_2])
  end

  def set_productor
    @productor = Productor.find(params[:id])
  end
end
