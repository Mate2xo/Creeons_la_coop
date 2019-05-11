# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  before_action :configure_permitted_parameters, if: :devise_controller?
  #  The following lines are useful when developping Pundit policies
  after_action :verify_authorized, except: :index, unless: :active_admin_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :active_admin_controller?

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

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  def pundit_user
    current_member
  end
end
