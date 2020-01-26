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
#  group                     :integer
#  invitation_token          :string
#  invitation_created_at     :datetime
#  invitation_sent_at        :datetime
#  invitation_accepted_at    :datetime
#  subscription_date         :datetime
#  invitation_limit          :integer
#  invited_by_type           :string
#  invited_by_id             :bigint(8)
#  invitations_count         :integer          default(0)
#  display_name              :string
#  moderator                 :boolean          default(FALSE)
#  cash_register_proficiency :integer          default("untrained")
#

require 'rails_helper'

RSpec.describe Member, type: :model do
  describe 'Model instanciation' do
    subject { described_class.new }

    describe 'Database' do
      it { is_expected.to have_db_column(:id).of_type(:integer) }
      it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:encrypted_password).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:first_name).of_type(:string) }
      it { is_expected.to have_db_column(:last_name).of_type(:string) }
      it { is_expected.to have_db_column(:display_name).of_type(:string) }
      it { is_expected.to have_db_column(:biography).of_type(:text) }
      it { is_expected.to have_db_column(:phone_number).of_type(:string) }
      it { is_expected.to have_db_column(:confirmed_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:subscription_date).of_type(:datetime) }
      it { is_expected.to have_db_column(:role).of_type(:integer) }
      it { is_expected.to define_enum_for(:role) }
      it { is_expected.to have_db_column(:group).of_type(:integer) }
      it { is_expected.to define_enum_for(:group) }
      it { is_expected.to have_db_column(:confirmation_token).of_type(:string) }
      it { is_expected.to have_db_column(:cash_register_proficiency).of_type(:integer) }
      it { is_expected.to define_enum_for(:cash_register_proficiency) }

      it { is_expected.to have_db_index(:confirmation_token) }
      it { is_expected.to have_db_index(:email).unique }
      it { is_expected.to have_db_index(:reset_password_token).unique }
    end

    describe 'associations' do
      it { is_expected.to accept_nested_attributes_for(:address).allow_destroy(true) }
      it { is_expected.to have_one(:address).dependent(:destroy) }
      it { is_expected.to have_many(:created_missions).class_name('Mission').with_foreign_key('author_id').dependent(:nullify) }
      it { is_expected.to have_many(:missions).through(:enrollments) }
    end

    describe "validations" do
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_presence_of(:display_name) }
    end
  end

  describe "#set_unique_display_name" do
    let(:member) { create :member }

    it "sets the display_name attribute on creation" do
      new_member = build :member
      new_member.save
      expect(new_member.reload.display_name).to eq "#{new_member.first_name} #{new_member.last_name}"
    end

    context "when a pre-existing member without :display_name is updated" do
      it "sets a display_name" do
        old_member = build :member
        old_member.save(validate: false)

        old_member.reload.save

        expect(old_member.display_name).to eq "#{old_member.first_name} #{old_member.last_name}"
      end
    end

    context "when a member is created with already existing first_name and last_name," do
      it "checks uniqueness of :display_name by appending it a number" do
        new_member = create :member, first_name: member.first_name,
                                     last_name: member.last_name
        expect(new_member.display_name).to eq "#{new_member.first_name} #{new_member.last_name} 1"
      end

      it "checks uniqueness of :display_name by appending it an incrementing number" do
        create :member, first_name: member.first_name,
                        last_name: member.last_name
        new_member = create :member, first_name: member.first_name,
                                     last_name: member.last_name
        expect(new_member.display_name).to eq "#{new_member.first_name} #{new_member.last_name} 2"
      end
    end

    context "when a member updates, without changing his/her name" do
      it "does not change :display_name" do
        member = create :member
        display_name = member.display_name
        member.update(phone_number: 'whatever')
        expect(member.reload.display_name).to eq display_name
      end
    end

    context "when a member updates, and the name is edited," do
      let(:first_name) { 'new' }
      let(:last_name) { 'name' }

      before { member.first_name, member.last_name = first_name, last_name }

      it "update :display_name accordingly" do
        member.save
        expect(member.reload.display_name).to eq "#{first_name} #{last_name}"
      end

      it "appends an number to :display_name if it already exists" do
        create :member, first_name: first_name, last_name: last_name
        member.save
        expect(member.reload.display_name).to eq "#{first_name} #{last_name} 1"
      end
    end
  end

  describe "#thredded_admin? (forum admin rights)" do
    context "when member is super admin," do
      subject { build_stubbed :member, :super_admin }

      it { is_expected.to be_thredded_admin }
    end

    context "when member is an admin," do
      subject { build_stubbed :member, :admin }

      it { is_expected.to be_thredded_admin }
    end

    context "when member is not an admin" do
      subject { build_stubbed :member }

      it { is_expected.not_to be_thredded_admin }
    end
  end

	describe "renewed_subscription" do
		context "when is the first subscription" do

			before(:each) do
				member = create :member
			end

			#before { Time.stub(:now) { DateTime.new(2001, 2, 5) } }
			#
			before {allow(Time).to receive(:now) { DateTime.new(2001, 2, 5) }}
			it { expect(member.subscription_date).to eq(DateTime.new(2002, 2, 4)) }

			#before { Time.stub(:now) { DateTime.new(2020, 7, 21) } }
			before {allow(Time).to receive(:now) { DateTime.new(2020, 7,21) }}
			it { expect(member.subscription_date).to eq(DateTime.new(2021, 7, 20)) }

			#before { Time.stub(:now) { DateTime.new(2023, 2, 1) } }
			before {allow(Time).to receive(:now) { DateTime.new(2023, 2, 1) }}
			it { expect(member.subscription_date).to eq(DateTime.new(2024, 1, 1)) }

			#before { Time.stub(:now) { DateTime.new(2001, 2, 5) } }
			before {allow(Time).to receive(:now) { DateTime.new(2001, 2, 5) }}
			it { expect(member.subscription_date).to eq(DateTime.new(2002, 2, 4)) }
		end
	end
	



end
