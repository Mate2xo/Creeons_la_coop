# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec', 'support', 'shared_examples.rb')

RSpec.describe "productors/index", type: :view do
  it_behaves_like "a view without missing translations" do
    before { assign(:productors, build_stubbed_list(:productor, 5)) }
  end
end
