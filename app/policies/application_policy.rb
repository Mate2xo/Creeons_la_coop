# frozen_string_literal: true

# NOTE: Up to Pundit v2.3.1, the inheritance was declared as
# `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
# In most cases the behavior will be identical, but if updating existing
# code, beware of possible changes to the ancestors:
# https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def destroy_all?
    admin? || super_admin?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  # NOTE: Be explicit about which records you allow access to!
  # def resolve
  #   scope.none
  # end
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  private

  def super_admin?
    return false if user.blank?

    user.role == 'super_admin'
  end

  def admin?
    return false if user.blank?

    user.role == 'admin'
  end

  def member?
    return false if user.blank?

    user.role == 'member'
  end

  def redactor?
    return false if user.blank?

    user.redactor?
  end
end
