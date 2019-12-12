# frozen_string_literal: true

require "rails_helper"
require Rails.root.join('spec', 'support', 'shared_examples.rb')

# rubocop: disable RSpec/DescribeClass
RSpec.describe "members/index" do
  it_behaves_like "a view without missing translations" do
    before { assign(:members, build_stubbed_list(:member, 5)) }
  end
end
# rubocop: enable RSpec/DescribeClass
