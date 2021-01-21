# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InfosHelper, type: :helper do
  describe '#infos_of_this_category' do
    it 'returns the infos of the indicated category' do
      event_infos = create_list :info, 2, category: 'event'
      create :info, category: 'management'

      returned_infos = helper.infos_of_this_category(Info.all, 'event')

      expect([returned_infos]).to include(event_infos)
    end

    it "doesn't return the infos of an other category that the indicated category" do
      create_list :info, 2, category: 'event'
      managment_info = create :info, category: 'management'

      returned_infos = helper.infos_of_this_category(Info.all, 'event')

      expect([returned_infos]).not_to include(managment_info)
    end
  end
end
