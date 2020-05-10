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

  context 'when a member has worked >= 3 hours this current month' do
    before { sign_in create :member, :admin }

    it 'shows a :ok status on the admin members index' do
      create :enrollment, member: member,
                          mission: create(:mission, start_date: 1.week.ago, due_date: 1.week.ago + 3.hours)

      visit admin_members_path

      expect(page).to have_content I18n.t 'active_admin.status_tag.yes'
    end

    context 'with <= 3 hours worked the previous month' do
      it 'does not show that member on the admin dashboard'
    end
  end

  context 'when a member has worked less than 3 hours this current month,' do
    before { sign_in create :member, :admin }

    it 'shows his/her month status as :incomplete on the members admin index' do
      create :enrollment, member: member

      visit admin_members_path

      expect(page).to have_content I18n.t 'active_admin.status_tag.no'
    end
  end

  context 'when a new month starts,' do
    context 'when a member has not worked 3 hours last month' do
      it 'shows that member on the admin dashboard'
    end
  end
end
