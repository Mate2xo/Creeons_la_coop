# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Members worked hours tracking', type: :feature do
  let(:member) { create :member }

  context 'when a member goes on his/her profile page,' do
    before { sign_in member }

    it 'shows the number of worked hours this month' do
      enrollment = create :enrollment, member: member

      visit edit_member_path member

      expect(page).to have_content enrollment.duration
    end

    it 'shows the number of worked hours during last month' do
      last_month_enrollment = create :enrollment,
                                     member: member,
                                     mission: create(:mission, start_date: 1.month.ago)

      visit edit_member_path member

      expect(page).to have_content last_month_enrollment.duration
    end

    it 'shows the number of worked hours during last last month' do
      last_last_month_enrollment = create :enrollment,
                                          member: member,
                                          mission: create(:mission, start_date: 2.months.ago)

      visit edit_member_path member

      expect(page).to have_content last_last_month_enrollment.duration
    end

    it 'does not raise errors if he/she has no enrollment' do
      expect { visit edit_member_path member }.not_to raise_error
    end
  end

  context 'when an admin is connected on admin index members' do
    before { sign_in create :member, :admin }

    it 'shows the number of worked hours during this month' do
      create_enrollments_for_the_last_three_months

      visit admin_members_path

      expect(page).to have_text "#{I18n.localize(Date.current, format: :only_month)} : 3.0"
    end

    it 'shows the number of worked hours during last month' do
      create_enrollments_for_the_last_three_months

      visit admin_members_path

      expect(page).to have_text "#{I18n.localize(Date.current - 1.month, format: :only_month)} : 3.0"
    end

    it 'shows the number of worked hours during last last month' do
      create_enrollments_for_the_last_three_months

      visit admin_members_path

      expect(page).to have_text "#{I18n.localize(Date.current - 2.months, format: :only_month)} : 3.0"
    end
  end

  context 'when a new month starts,' do
    context 'when a member has not worked 3 hours last month' do
      it 'shows that member on the admin dashboard'
    end
  end

  def create_enrollments_for_the_last_three_months
    slot = 1.week.ago.clamp(Date.current.at_beginning_of_month, Date.current)
    3.times do
      create :enrollment, member: member,
                          mission: create(:mission, start_date: slot, due_date: slot + 3.hours)
      slot -= 1.month
    end
  end
end
