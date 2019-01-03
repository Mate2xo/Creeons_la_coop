# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def super_admin?
    member_signed_in? && current_member.role == "super_admin"
  end
  
  def admin?
    member_signed_in? && current_member.role == "admin"
  end
  
  protected

  def configure_permitted_parameters
    added_attrs = %i[first_name biography last_name phone_number email password password_confirmation remember_me avatar]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
