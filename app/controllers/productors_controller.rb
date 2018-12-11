class ProductorsController < ApplicationController
	before_action :authenticate_member!

	def index
		@productors = Productor.all
	end
	
	def new
		if current_member.role == "super_admin" || current_member.role == "admin"  
			@productor = Productor.new
			@productor_address = @productor.build_address
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
		@productor = Productor.find(params[:id])

		# GMaps integration
		require "addressable/uri"
		@valide = "addresse invalide"
		url = "7 rue de la haute pierre 78620"
		if (@address = Addressable::URI.parse(url).normalize.to_str) != (nil || "")
			response = RestClient.get ("https://maps.googleapis.com/maps/api/geocode/json?address=" + @address + "+france&key=" + Rails.application.credentials[:google_key] ), {accept: :json}
			response = JSON.parse(response.body)
			if response["status"] == "OK" && response["results"][0]
				@lat = response["results"][0]["geometry"]["location"]["lat"]
				@lng = response["results"][0]["geometry"]["location"]["lng"]
				puts @lat
				puts @lng
				@valide = "addresse valide"
			end
		end
  end

  def edit
		if current_member.role == "super_admin" || current_member.role == "admin"  
			@productor = Productor.find(params[:id])
			@productor_address = @productor.address || @productor.build_address
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
		params.require(:productor).permit(:name, :description, :phone_number, address_attributes: [:id, :postal_code, :city, :street_name_1, :street_name_2])
	end
end
