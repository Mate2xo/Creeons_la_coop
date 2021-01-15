# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'An info request', type: :request do
  let(:member) { create :member }

  before { sign_in create :member }

  describe 'GET index' do
    subject(:get_infos) { get infos_path }

    it 'renders the view' do
      create_list :info, 3

      get_infos

      expect(response).to be_successful
    end
  end
end
