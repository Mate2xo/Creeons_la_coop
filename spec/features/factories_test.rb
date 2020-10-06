# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Factories :' do
  FactoryBot.factories.map(&:name).each do |factory_name|
    describe "the #{factory_name} factory" do
      it 'is valid' do
        expect(build(factory_name)).to be_valid
      end
    end
  end
end
