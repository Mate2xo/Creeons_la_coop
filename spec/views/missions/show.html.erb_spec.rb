# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec/support/shared_examples.rb')

RSpec.describe 'missions/show' do
  around { |example| without_partial_double_verification { example.call } } # To allow stubbing #policy helper

  context 'with a :standard mission' do
    let(:mission) { assign :mission, build_stubbed(:mission, genre: :standard) }

    it_behaves_like 'a view without missing translations' do
      before do
        member = build_stubbed(:member)
        allow(view).to receive_messages current_member: member, policy: Pundit.policy(member, mission)
      end
    end
  end

  context 'with a :regulated mission' do
    let(:mission) { assign :mission, build_stubbed(:mission, :regulated) }

    it_behaves_like 'a view without missing translations' do
      before do
        member = build_stubbed(:member)
        allow(view).to receive_messages current_member: member, policy: Pundit.policy(member, mission)
      end
    end
  end

  context 'with an :event mission' do
    let(:mission) { assign :mission, build_stubbed(:mission, :event) }

    it_behaves_like 'a view without missing translations' do
      before do
        member = build_stubbed(:member)
        allow(view).to receive_messages current_member: member, policy: Pundit.policy(member, mission)
      end
    end
  end

  it 'has no missing translations' do
    mission = build_stubbed(:mission)
    assign(:mission, mission)
    member = build_stubbed(:member)
    allow(view).to receive(:current_member) { member }
    policy = Pundit.policy(member, mission)
    allow(view).to receive(:policy) { policy }

    render
    expect { render }.not_to raise_error
  end

  it_behaves_like 'a view without missing translations' do
    before do
      # include Pundit
      mission = build_stubbed(:mission)
      assign(:mission, mission)
      member = build_stubbed(:member)
      allow(view).to receive(:current_member) { member }
      allow(view).to receive(:policy) { Pundit.policy(member, mission) }
    end
  end
end
