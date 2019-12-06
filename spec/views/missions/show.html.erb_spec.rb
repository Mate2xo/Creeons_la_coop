# frozen_string_literal: true

require "rails_helper"
require Rails.root.join('spec', 'support', 'shared_examples.rb')

RSpec.describe "missions/show", type: :view do
  it_behaves_like "a view without missing translations" do
    before {
      assign(:mission, build_stubbed(:mission))
      allow(view).to receive(:current_member) { build :member }
    }
  end
end
