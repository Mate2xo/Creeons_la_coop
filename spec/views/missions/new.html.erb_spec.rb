# frozen_string_literal: true

require "rails_helper"
require Rails.root.join('spec', 'support', 'shared_examples.rb')

RSpec.describe "missions/new", type: :view do
  it_behaves_like "a view without missing translations" do
    before { assign(:mission, build(:mission)) }
  end
end
