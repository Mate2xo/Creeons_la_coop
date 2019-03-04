# frozen_string_literal: true

# == Schema Information
#
# Table name: infos
#
#  id         :bigint(8)        not null, primary key
#  content    :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint(8)
#

require 'rails_helper'

RSpec.describe Info, type: :model do
  describe 'Model instanciation' do
    subject { described_class.new }

    describe 'Database' do
      it { is_expected.to have_db_column(:content).of_type(:text) }
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_index(:author_id) }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of(:title) }
    end

    describe 'associations' do
      it { is_expected.to belong_to(:author).class_name('Member') }
    end
  end
end
