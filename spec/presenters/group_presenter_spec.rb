require 'rails_helper'

describe GroupPresenter do
  describe '#all_manager_links' do
    subject(:all_manager_links) { described_class.new(group).all_manager_links }
    let(:group) { create(:group, :with_members_and_managers) }

    it 'concatenates links to associated managers' do
      expect(all_manager_links).to match(%Q{href="/members/#{group.managers.first.id}})
    end
  end
end
