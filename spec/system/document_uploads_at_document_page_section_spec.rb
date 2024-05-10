# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DocumentUploadsAtInfoSections' do
  context 'when a regular member accesses the page' do
    before { sign_in create :member }

    it 'does not show the document upload form' do
      visit infos_path(anchor: 'documents')

      expect(page).not_to have_content('Ajouter un document')
    end

    it 'does not show the delete button on a document' do
      create(:document, :with_file)

      visit infos_path(anchor: 'documents')

      expect(page).not_to have_link(I18n.t('main_app.views.application.buttons.destroy'))
    end
  end

  context 'when an admin uploads a document' do
    subject(:fill_in_upload_form) do
      attach_file('document_file', Rails.root.join('spec/support/fixtures/erd.pdf'))
      click_button 'Ajouter'
    end

    before do
      sign_in create(:member, :admin)
      visit documents_path(anchor: 'documents')
    end

    it 'shows the uploaded document on the documents/index#document view' do
      fill_in_upload_form
      expect(page).to have_content 'erd.pdf'
    end

    context 'when javascript is enabled in the browser', :js do
      it 'show the uploaded document on the documents/index#document view' do
        fill_in_upload_form
        expect(page).to have_content 'erd.pdf'
      end
    end
  end

  context 'when an admin deletes a document' do
    subject(:submit_document_destruction) do
      click_on I18n.t('main_app.views.application.buttons.destroy')
      page.driver.browser.switch_to.alert.accept
    end

    before do
      sign_in create(:member, :admin)
      create(:document, :with_file)
      visit documents_path(anchor: 'documents')
    end

    it 'deletes the document from documents/index#document view' do
      submit_document_destruction
      expect(page).not_to have_content 'erd.pdf'
    end

    context 'when javascript is enabled in the browser', :js do
      it 'deletes the document from from the documents/index#document view' do
        submit_document_destruction
        expect(page).not_to have_content 'erd.pdf'
      end
    end
  end
end
