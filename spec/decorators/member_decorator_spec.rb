# frozen_string_literal: true

require 'rails_helper'
require 'draper/test/rspec_integration'

RSpec.describe MemberDecorator do
  describe '#hours_worked_in_the_three_last_months' do
    let(:generate_member_decorator) { described_class.new(build_stubbed(:member)) }

    context 'when no options are given' do
      it 'return the html version' do
        member_decorator = generate_member_decorator

        content = member_decorator.hours_worked_in_the_three_last_months

        expect(content).to include('<p>')
      end
    end

    context 'when the :csv option is true' do
      it 'return the csv version' do
        member_decorator = generate_member_decorator

        content = member_decorator.hours_worked_in_the_three_last_months(csv: true)

        expect(content).not_to include('<p>')
      end
    end
  end
end
