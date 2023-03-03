# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id                        :bigint(8)        not null, primary key
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  first_name                :string
#  last_name                 :string
#  biography                 :text
#  phone_number              :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  role                      :integer          default("member")
#  confirmation_token        :string
#  confirmed_at              :datetime
#  confirmation_sent_at      :datetime
#  unconfirmed_email         :string
#  invitation_token          :string
#  invitation_created_at     :datetime
#  invitation_sent_at        :datetime
#  invitation_accepted_at    :datetime
#  invitation_limit          :integer
#  invited_by_type           :string
#  invited_by_id             :bigint(8)
#  invitations_count         :integer          default(0)
#  display_name              :string
#  moderator                 :boolean          default(FALSE)
#  cash_register_proficiency :integer          default("untrained")
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
  validates :display_name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }

  before_validation :set_unique_display_name

  enum role: { member: 0, admin: 1, super_admin: 2 }
  enum cash_register_proficiency: { untrained: 0,newbie: 1, beginner: 2, proficient: 3 }

  def thredded_admin?
    admin? || super_admin?
  end

  # @return [Float]
  # @param date [Date]
  def monthly_worked_hours(date)
    family_enrollments.has_worked_this_month(date)
                      .reduce(0.0) { |sum, enrollment| sum + enrollment.duration }
  end

  def redactor?
    groups.each do |group|
      return true if group.roles.include?('redactor')
    end
    false
  end

  private

  def set_unique_display_name
    return unless display_name.nil? || changed.any?('first_name') || changed.any?('last_name')

    display_name = "#{first_name} #{last_name}"

    i = 0
    display_name = "#{first_name} #{last_name} #{i += 1}" while Member.exists?(display_name: display_name)

    self.display_name = display_name
  end

  def family_enrollments
    return enrollments if register_id.nil?

    Enrollment.joins(:member)
              .where(members: { register_id: register_id })
  end
end
