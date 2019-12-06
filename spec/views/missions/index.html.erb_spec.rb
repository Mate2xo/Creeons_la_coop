# frozen_string_literal: true

require "rails_helper"
require Rails.root.join('spec', 'support', 'shared_examples.rb')

RSpec.describe "missions/index", type: :view do
  it_behaves_like "a view without missing translations" do
    before {
      assign(:missions, build_stubbed_list(:mission, 3))
      allow(view).to receive(:current_member) { build :member }
    }
  end
end
