class CreateShortUrls < ActiveRecord::Migration[8.1]
  def change
    create_table :short_urls do |t|
      t.string :original_url
      t.string :code

      t.timestamps
    end
    add_index :short_urls, :code
  end
end
