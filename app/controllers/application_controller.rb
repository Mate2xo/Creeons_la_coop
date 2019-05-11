# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  before_action :configure_permitted_parameters, if: :devise_controller?
  #  The following lines are useful when developping Pundit policies
  after_action :verify_authorized, except: %i[index show], unless: %i[active_admin_controller? devise_controller?]
  # after_action :verify_policy_scoped, only: :index, unless: :active_admin_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to root_path
  end
end
