# frozen_string_literal: true

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
    subject { described_class.new(file: fixture_file_upload('fixture.json')) }

    it { is_expected.not_to be_valid }
  end

  context 'without any attached file' do
    subject(:document) { build(:document, file: nil) }

    it { is_expected.not_to be_valid }
  end
end
