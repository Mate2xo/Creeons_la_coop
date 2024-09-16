# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/forum' do
  subject(:index) { get thredded_path }

  before { sign_in create(:member) }

  it 'has an :ok HTTP status' do
    index
    expect(response).to have_http_status :ok
  end
end
