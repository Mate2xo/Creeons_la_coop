# frozen_string_literal: true

class StaticPagesPolicy < ApplicationPolicy
  def home
    true
  end

  def ensavoirplus
    true
  end

  def dashboard?
    member_signed_in?
  end
end
