# frozen_string_literal: true

require 'rails_helper'
require 'draper/test/rspec_integration'

RSpec.describe MemberDecorator do
  describe '#hours_worked_in_the_last_three_months' do
    let(:generate_member_decorator) { described_class.new(build_stubbed(:member)) }

    context 'when no options are given' do
      it 'return the html version' do
        member_decorator = generate_member_decorator

        content = member_decorator.hours_worked_in_the_last_three_months

        expect(content).to include('<p>')
      end
    end
  end
end
