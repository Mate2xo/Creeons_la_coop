# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string
#  last_name              :string
#  biography              :text
#  phone_number           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string           default("member")
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  group                  :integer
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :bigint(8)
#  invitations_count      :integer          default(0)
#  display_name           :string
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
      it { is_expected.to have_db_column(:role).of_type(:string).with_options(default: 'member') }
      it { is_expected.to have_db_column(:confirmation_token).of_type(:string) }

      it { is_expected.to have_db_index(:confirmation_token) }
      it { is_expected.to have_db_index(:email).unique }
      it { is_expected.to have_db_index(:reset_password_token).unique }
    end

    describe 'associations' do
      it { is_expected.to accept_nested_attributes_for(:address).allow_destroy(true) }
      it { is_expected.to have_one(:address).dependent(:destroy) }
      it { is_expected.to have_many(:created_missions).class_name('Mission').with_foreign_key('author_id').dependent(:nullify) }
      it { is_expected.to have_and_belong_to_many(:missions).dependent(:nullify) }
    end

    describe "validations" do
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:display_name) }

      let(:member) { create :member }

      it "sets the display_name attribute on save" do
        expect(member).to receive(:set_unique_display_name)
        member.save
        expect(member.reload.display_name).to eq "#{member.first_name} #{member.last_name}"
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
    end
  end

  describe "forum admin rights" do
    context "when member is super admin," do
      subject { build_stubbed :member, :super_admin }

      it { expect(subject.thredded_admin?).to be_truthy }
    end

    context "when member is an admin," do
      subject { build_stubbed :member, :admin }

      it { expect(subject.thredded_admin?).to be_truthy }
    end

    context "when member is not an admin" do
      subject { build_stubbed :member }

      it { expect(subject.thredded_admin?).to be_falsy }
    end
  end
end
