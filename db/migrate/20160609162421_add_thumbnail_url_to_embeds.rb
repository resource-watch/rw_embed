class AddThumbnailUrlToEmbeds < ActiveRecord::Migration[5.0]
  def change
    add_column :embeds, :thumbnail_url, :string
  end
end
