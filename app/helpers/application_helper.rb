# frozen_string_literal: true

module ApplicationHelper
  def super_admin?
    member_signed_in? && current_member.role == "super_admin"
  end
  
  def admin?
    member_signed_in? && current_member.role == "admin"
  end 
end
