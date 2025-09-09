# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DocumentUploadsAtInfoSections' do
  before { use_fast_non_js_browser }

  context 'when a regular member accesses the page' do
    before { sign_in create :member }

    it 'does not show the document upload form' do
      visit infos_path(anchor: 'documents')

      expect(page).to have_no_content('Ajouter un document')
    end

    it 'does not show the delete button on a document' do
      create(:document)

      visit infos_path(anchor: 'documents')

      expect(page).to have_no_link(I18n.t('main_app.views.application.buttons.destroy'))
    end
  end

  context 'when an admin deletes a document' do
    subject(:submit_document_destruction) do
      visit documents_path(anchor: 'documents')
      click_on I18n.t('main_app.views.application.buttons.destroy')
      page.driver.browser.switch_to.alert.accept
    end

    before do
      use_headless_javascript_browser
      sign_in create(:member, :admin)
      create(:document)
    end

    it 'deletes the document from documents/index#document view' do
      submit_document_destruction
      expect(page).to have_no_content 'erd.pdf'
    end
  end
end
