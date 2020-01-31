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
#  end_subscription          :date
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
      it { is_expected.to have_db_column(:end_subscription).of_type(:date) }
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

			before(:each) do
				@member = FactoryBot.create(:member)
			end

		context "when is the first subscription" do

			it { 
				allow(Date).to receive(:today) { Date.new(2001, 2, 5) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2002, 2, 4)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2121, 7,21) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2122, 7, 20)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2023, 2, 1) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2024, 1, 31)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2100, 11, 15) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2101, 11, 14)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2020, 2, 5) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2021, 2, 4)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2399, 10, 24) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2400, 10, 23)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2060, 2, 29) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2061, 2, 28)) 
			}

		end

		context "when the subscription is outdated" do

			it { 
				allow(Date).to receive(:today) { Date.new(2001, 2, 5) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2002, 2, 4)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2121, 7,21) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2122, 7, 20)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2023, 2, 1) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2024, 1, 31)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2100, 11, 15) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2101, 11, 14)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2020, 2, 5) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2021, 2, 4)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2399, 10, 24) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2400, 10, 23)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2060, 2, 29) }
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2061, 2, 28)) 
			}

		end
	
		context "when is subscription is still active" do 

			it { 
				allow(Date).to receive(:today) { Date.new(2001, 2, 5) }
				@member.end_subscription = Date.new(2001, 4, 7)
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2002, 4, 7)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2121, 7,21) }
				@member.end_subscription = Date.new(2121, 10, 5)
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2122, 10, 5)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(3014, 5, 5) }
				@member.end_subscription = Date.new(3015, 2, 2)
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(3016, 2, 2)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2001, 11, 11) }
				@member.end_subscription = Date.new(2001, 11, 11)
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2002, 11, 11)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2004, 2, 5) }
				@member.end_subscription = Date.new(2004, 2, 12)
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2005, 2, 12)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2399, 10, 24) }
				@member.end_subscription = Date.new(2400, 2, 9)
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2401, 2, 9)) 
			}

			it { 
				allow(Date).to receive(:today) { Date.new(2015, 7, 24) }
				@member.end_subscription = Date.new(2015, 8, 26)
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2016, 8, 26)) 
			}
		
			it { 
				allow(Date).to receive(:today) { Date.new(2024, 1, 24) }
				@member.end_subscription = Date.new(2024, 2, 29)
				@member.renewed_subscription
				expect(@member.end_subscription).to eq(Date.new(2025, 2, 28)) 
			}
		
		end

	end

end
