# frozen_string_literal: true

require "rails_helper"
require Rails.root.join('spec', 'support', 'shared_examples.rb')

RSpec.describe "missions/show", type: :view do

  # TODO: try to make #policy method from Pundit usable from a tested view
  # it_behaves_like "a view without missing translations" do
  #   before {
  #     assign(:mission, build_stubbed(:mission))
  #     member = build_stubbed :member
  #     allow(view).to receive(:current_member) { member }
  #   }
  # end
end
