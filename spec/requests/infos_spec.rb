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

  describe 'GET show' do
    subject(:get_info) { get info_path(info) }

    let(:info) { create :info }

    it 'renders the view' do
      get_info

      expect(response).to be_successful
    end
  end

  describe 'GET new' do
    subject(:get_new_info) { get new_info_path }

    it 'renders the view' do
      get_new_info
      follow_redirect!

      expect(response).to be_successful
    end
  end

  describe 'POST' do
    subject(:post_info) { post infos_path, params: { info: info_params } }

    before { sign_in create :member, :super_admin }

    let(:info_params) { attributes_for(:info) }

    it 'creates the info' do
      post_info

      info_params.each do |key, value|
        expect(Info.last.attributes[key.to_s]).to eq value
      end
    end

    it 'renders the show view' do
      post_info
      follow_redirect!

      expect(response).to be_successful
    end
  end

  describe 'GET edit' do
    it 'rends the view' do
      info = create :info

      get edit_info_path(info.id)
      follow_redirect!

      expect(response).to be_successful
    end
  end

  describe 'PUT' do
    subject(:put_info) { put info_path(info.id), params: { info: info_params } }

    let(:info) { create :info }
    let(:info_params) { { title: 'updated_info', content: 'updated_text' } }

    before { sign_in create :member, :super_admin }

    it 'updates the info' do
      put_info

      info_params.each do |key, value|
        expect(Info.last.attributes[key.to_s]).to eq value
      end
    end

    it 'renders the show view' do
      put_info
      follow_redirect!

      expect(response).to be_successful
    end
  end

  describe 'Delete' do
    before { sign_in create :member, :super_admin }

    it 'deletes the info' do
      info = create :info

      delete info_path(info.id)

      expect(Info.find_by(id: info.id)).to be_nil
    end
  end
end
