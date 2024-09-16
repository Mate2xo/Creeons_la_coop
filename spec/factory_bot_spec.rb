# frozen_string_literal: true

require 'rails_helper'

BROKEN_FACTORIES = %i[
  messageboard
  topic
  post
].freeze

RSpec.describe FactoryBot do
  # Ideally, this list should be empty. When you work on a model, try to make its factory valid by default
  let(:factories_to_check) do
    described_class.factories.reject do |f|
      f.name.in?(BROKEN_FACTORIES)
    end
  end

  it 'has valid factories' do # rubocop:disable RSpec/NoExpectationExample
    described_class.lint(factories_to_check, traits: true)
  end

  BROKEN_FACTORIES.each do |factory|
    context "with the :#{factory} factory" do
      pending 'does not build valid objects. See https://rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#best-practices'
    end
  end
end
