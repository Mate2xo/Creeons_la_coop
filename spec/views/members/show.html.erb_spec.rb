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

RSpec.describe "members/show.html.erb", type: :view do
	context 'it display the end_subscription' do
		it "displays end_subscription" do
			assign(:member, build(:member, end_subscription: Date.new(2020, 10, 10) ))
      allow(view).to receive(:current_member) { build_stubbed :member }
			render
			expect(rendered).to match '10-10-2020' 
		end
	end
end
# rubocop: enable RSpec/DescribeClass
