class AddPublishedToEmbeds < ActiveRecord::Migration[5.0]
  def change
    add_column :embeds, :published, :boolean, default: false, index: true
  end
end
