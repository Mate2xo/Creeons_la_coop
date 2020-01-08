# frozen_string_literal: true

require "rails_helper"
require Rails.root.join('spec', 'support', 'shared_examples.rb')

# rubocop: disable RSpec/DescribeClass
RSpec.describe "members/show" do
  it_behaves_like "a view without missing translations" do
    before {
      assign(:member, build_stubbed(:member))
      allow(view).to receive(:current_member) { build_stubbed :member }
    }
  end
end
# rubocop: enable RSpec/DescribeClass
