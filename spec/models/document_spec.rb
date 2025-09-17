# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id              :bigint           not null, primary key
#  category        :string           default("weekly_orders")
#  date            :date
#  name            :string
#  published       :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  category_id     :bigint
#  sub_category_id :bigint
#
# Indexes
#
#  index_documents_on_category_id      (category_id)
#  index_documents_on_sub_category_id  (sub_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => documents_categories.id)
#  fk_rails_...  (sub_category_id => documents_sub_categories.id)
#
require 'rails_helper'
require Rails.root.join('spec/support/shared_examples')

RSpec.describe Document do
  subject(:document) { build(:document) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to belong_to(:sub_category).optional }

  context 'with a sub-category not belonging to its category' do
    subject(:document) { build(:document, sub_category: build(:documents_sub_category)) }

    it { is_expected.not_to be_valid }

    it_behaves_like 'a model without missing validation error translations' do
      let(:resource) { document }
    end
  end

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
