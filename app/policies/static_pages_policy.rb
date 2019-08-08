# frozen_string_literal: true

class StaticPagesPolicy < ApplicationPolicy
  def home
    true
  end

  def about_us
    true
  end

  def dashboard?
    member_signed_in?
  end
end
