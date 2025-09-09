# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  published   :boolean          default(FALSE)
#  category    :string           default("weekly_orders")
#  name        :string
#  date        :date
#  category_id :bigint
#
require 'rails_helper'

RSpec.describe Document do
  subject(:document) { build(:document) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to belong_to(:category) }

  context 'with a file of a whitelisted content_type' do
    subject(:document) { build(:document, file: fixture_file_upload('test.txt')) }

    it { is_expected.to be_valid }
  end

  context 'with a file of a non-whitelisted content_type' do
    subject(:document) { build(:document, file: fixture_file_upload('fixture.json')) }

    it { is_expected.not_to be_valid }
  end

  context 'without any attached file' do
    subject(:document) { build(:document, file: nil) }

    it { is_expected.not_to be_valid }
  end
end
