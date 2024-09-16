require 'rails_helper'

RSpec.describe Document, type: :model do
  context 'with a file of a whitelisted content_type' do
    subject { Document.new(file: fixture_file_upload('test.txt')) }

    it { is_expected.to be_valid }
  end

  context 'with a file of a non-whitelisted content_type' do
    subject { Document.new(file: fixture_file_upload('fixture.json')) }

    it { is_expected.not_to be_valid }
  end

  context 'without any attached file' do
    subject { Document.new(file: nil) }

    it { is_expected.not_to be_valid }
  end
end
