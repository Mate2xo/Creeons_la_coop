# frozen_string_literal: true

module ApplicationHelper
  def super_admin?
    member_signed_in? && current_member.role == "super_admin"
  end

  def admin?
    member_signed_in? && current_member.role == "admin"
  end

  def redactor?
    member_signed_in? && !super_admin? && !admin? && current_member.redactor?
  end
end
