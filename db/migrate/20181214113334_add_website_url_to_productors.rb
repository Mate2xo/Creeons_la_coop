class AddWebsiteUrlToProductors < ActiveRecord::Migration[5.2]
  def change
    add_column :productors, :website_url, :string
  end
end
