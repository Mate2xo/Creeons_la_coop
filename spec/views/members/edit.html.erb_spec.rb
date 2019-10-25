# frozen_string_literal: true

require "rails_helper"
require Rails.root.join('spec', 'support', 'shared_examples.rb')

RSpec.describe "members/edit" do
  it_behaves_like "a view without missing translations" do
    before { assign(:member, build_stubbed(:member)) }
  end
end
