class CreateSources < ActiveRecord::Migration[5.0]
  def change
    create_table :sources, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string  :acronym
      t.string  :url
      t.string  :logo_url
      t.boolean :partner, default: false

      t.timestamps
    end
  end
end
