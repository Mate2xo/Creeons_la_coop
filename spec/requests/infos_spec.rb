# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'An info request', type: :request do
  let(:member) { create :member }

  describe 'GET index' do
    subject(:get_infos) { get infos_path }

    context 'when user is signed ?' do
      before { sign_in create :member }

      it 'renders the view' do
        create_list :info, 3

        get_infos

        expect(response).to be_successful
      end
    end

    context 'when user is not signed ?' do
      it 'renders the view' do
        create_list :info, 3, published: true

        get_infos

        expect(response).to be_successful
      end

      it "doesn't rend the infos with published attribute set to false" do
        create_list :info, 3, published: true
        create :info, title: 'not_published_info', published: false

        get_infos

        expect(response.body).not_to include('not_published_info')
      end
    end
  end

  describe 'GET show' do
    subject(:get_info) { get info_path(info) }

    let(:info) { create :info }

    before { sign_in create :member }

    it 'renders the view' do
      get_info

      expect(response).to be_successful
    end
  end
end
