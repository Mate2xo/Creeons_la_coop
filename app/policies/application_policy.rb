# frozen_string_literal: true

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

    user.role == "super_admin"
  end

  def admin?
    return false if user.blank?

    user.role == "admin"
  end

  def member?
    return false if user.blank?

    user.role == "member"
  end

  def redactor?
    return false if user.blank?

    user.redactor?
  end
end
