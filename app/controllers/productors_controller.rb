class ProductorsController < ApplicationController
	before_action :authenticate_member!

	def index
		@productors = Productor.all
	end
	
	def new
		if current_member.role == "super_admin" || current_member.role == "admin"  
			@productor = Productor.new
		else
			redirect_to productors_path 
		end
	end

	def create
		@productor = Productor.new(permitted_params)
		if @productor.save
			flash[:notice] = "Le producteur a bien été créé"
			redirect_to @productor
		else
			flash[:error] = "Une erreur est survenue, veuillez recommencer l'opération"
			redirect_to new_productor_path
		end
	end
	

	def show
		require "addressable/uri"
		@productor = Productor.find(params[:id])
		if @productor.address
			url = @productor.address.postal_code + " " + @productor.address.city + " " + @productor.address.street_name_1 + " " + @productor.address.street_name_2
			@valide = "addresse invalide"
			if (@address = Addressable::URI.parse(url).normalize.to_str) != (nil || "")
				response = RestClient.get ("https://maps.googleapis.com/maps/api/geocode/json?address=" + @address + "+france&key=" + Rails.application.credentials[:google_key] ), {accept: :json}
				response = JSON.parse(response.body)
				if response["status"] == "OK" && response["results"][0]
					@lat = response["results"][0]["geometry"]["location"]["lat"]
					@lng = response["results"][0]["geometry"]["location"]["lng"]
					@valide = "addresse valide"
				end
			end
		end
  end

  def edit
		if current_member.role == "super_admin" || current_member.role == "admin"  
			@productor = Productor.find(params[:id])
		else
			redirect_to productors_path 
  	end
	end
	
	def update
		@productor = Productor.find(params[:id])
			if @productor.update_attributes(permitted_params)
				flash[:notice] = "Le producteur a bien été mis à jour"
				redirect_to @productor
			else
				flash[:error] = "Une erreur est survenue, veuillez recommencer l'opération"
				redirect_to edit_productor_path(@productor.id)
			end
	end
	

	private

	def permitted_params
		params.require(:productor).permit(:name, :description, :phone_number, :avatar)
	end
end
