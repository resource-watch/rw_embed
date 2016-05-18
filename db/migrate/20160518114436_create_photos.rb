class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos, id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
      t.string :source_url, null: false

      t.timestamps
    end
  end
end
