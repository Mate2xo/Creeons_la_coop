# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec', 'support', 'shared_examples.rb')

RSpec.describe "productors/show", type: :view do
  it_behaves_like "a view without missing translations" do
    before { assign(:productor, build(:productor)) }
  end
end
