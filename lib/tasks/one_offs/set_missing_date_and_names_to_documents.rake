# frozen_string_literal: true

namespace :one_offs do
  # TODO: delete-me
  desc 'Old record have no name or date; this fills up these attributes from the :name and :created_at'
  task set_missing_date_and_names_to_documents: :environment do
    Document.where(name: nil).or(Document.where(date: nil)).find_each do |doc|
      attributes = {}
      attributes[:name] = doc.file.filename.to_s unless doc.name
      attributes[:date] = doc.created_at unless doc.date

      doc.update! attributes
    end
  end
end
