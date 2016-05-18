class CreateEmbedApps < ActiveRecord::Migration[5.0]
  def change
    create_table :embed_apps, id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
      t.string :source_url, null: false
      t.jsonb  :settings, default: '{}'
      t.text   :source_code

      t.timestamps
    end
  end
end
