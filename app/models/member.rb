# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id                        :bigint           not null, primary key
#  biography                 :text
#  cash_register_proficiency :integer          default("newcomer")
#  confirmation_sent_at      :datetime
#  confirmation_token        :string
#  confirmed_at              :datetime
#  display_name              :string
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  first_name                :string
#  invitation_accepted_at    :datetime
#  invitation_created_at     :datetime
#  invitation_limit          :integer
#  invitation_sent_at        :datetime
#  invitation_token          :string
#  invitations_count         :integer          default(0)
#  invited_by_type           :string
#  last_name                 :string
#  moderator                 :boolean          default(FALSE)
#  phone_number              :string
#  remember_created_at       :datetime
#  reset_password_sent_at    :datetime
#  reset_password_token      :string
#  role                      :integer          default("member")
#  unconfirmed_email         :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  invited_by_id             :bigint
#  register_id               :integer
#
# Indexes
#
#  index_members_on_confirmation_token                 (confirmation_token)
#  index_members_on_email                              (email) UNIQUE
#  index_members_on_invitation_token                   (invitation_token) UNIQUE
#  index_members_on_invitations_count                  (invitations_count)
#  index_members_on_invited_by_id                      (invited_by_id)
#  index_members_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_members_on_reset_password_token               (reset_password_token) UNIQUE
#  members_display_name_lower                          (lower((display_name)::text) text_pattern_ops) UNIQUE
#

# The websites users. Their 'role' attributes determines if fhey're an unvalidated user, a member, admin or super-admin
class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one_attached :avatar

  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  has_many :group_managers, dependent: :destroy, foreign_key: :manager, inverse_of: :manager
  has_many :managed_groups, class_name: 'Group', inverse_of: :managers, dependent: :nullify, through: :group_managers
  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members

  has_many :created_missions, class_name: 'Mission', inverse_of: 'author', foreign_key: 'author_id', dependent: :nullify
  has_many :enrollments, dependent: :destroy
  has_many :missions, through: :enrollments

  has_many :member_static_slots, dependent: :destroy
  has_many :static_slots, through: :member_static_slots
  accepts_nested_attributes_for :member_static_slots, allow_destroy: true
  accepts_nested_attributes_for :group_members
  accepts_nested_attributes_for :static_slots
  has_many :created_infos, class_name: 'Info', inverse_of: 'author', foreign_key: 'author_id', dependent: :nullify

  has_and_belongs_to_many :managed_productors, class_name: 'Productor'

  has_many :history_of_static_slot_selections, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :display_name, presence: true, uniqueness: {case_sensitive: false}, length: {maximum: 50}

  before_validation :set_unique_display_name

  enum :role, {member: 0, admin: 1, super_admin: 2}
  attribute :cash_register_proficiency, :integer # TODO: remove-me with Rails 7.2. See https://github.com/rails/rails/issues/49717
  enum :cash_register_proficiency,
       {newcomer: -1, untrained: 0, beginner: 1, proficient: 2, close_out: 3},
       default: :newcomer

  def self.ransackable_attributes(auth_object = nil)
    return [] unless auth_object

    case auth_object.user.role.to_sym
    when :super_admin, :admin
      column_names -
        %w[encrypted_password reset_password_token confirmation_token invitation_token] +
        _ransackers.keys
    else
      []
    end
  end

  def self.ransackable_associations(auth_object = nil)
    return [] unless auth_object

    case auth_object.user.role.to_sym
    when :super_admin, :admin
      %i[missions enrollments]
    else
      []
    end
  end

  def thredded_admin?
    admin? || super_admin?
  end

  # @return [Float]
  # @param date [Date]
  def monthly_worked_hours(date)
    family_enrollments.has_worked_this_month(date)
                      .reduce(0.0) { |sum, enrollment| sum + enrollment.duration }
  end

  # Returns true if the member belongs to *any* group with the 'redactor' role.
  def redactor?
    groups.each do |group|
      return true if group.roles.include?('redactor')
    end
    false
  end

  # @return [String] The combined first & last name of the member.
  def full_name = "#{first_name} #{last_name}"

  private

  # Sets a unique display name for the member based on their first and last name.
  # If a duplicate exists, appends an incrementing number to ensure uniqueness.
  def set_unique_display_name
    return unless display_name.nil? || changed.any?('first_name') || changed.any?('last_name')

    display_name = "#{first_name} #{last_name}"

    i = 0
    display_name = "#{first_name} #{last_name} #{i += 1}" while Member.exists?(display_name: display_name)

    self.display_name = display_name
  end

  # TODO: this causes an N+1 on Admin::Members#index
  def family_enrollments
    return enrollments if register_id.nil?

    Enrollment.joins(:member)
              .where(members: {register_id: register_id})
  end
end
