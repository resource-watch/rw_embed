class CreateEmbeds < ActiveRecord::Migration[5.0]
  def change
    create_table :embeds, id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
      t.uuid    :embedable_id
      t.string  :embedable_type
      t.string  :title,              null: false
      t.string  :slug
      t.text    :summary
      t.text    :content
      t.integer :source_type,        default: 0, index: true
      t.integer :status,             default: 0, index: true       # status(in process - 0, saved - 1verified - 2, failed - 3)

      t.timestamps
    end

    add_index :embeds, ['embedable_id', 'embedable_type'], name: 'index_embeds_on_source_and_embedable_type', unique: true
  end
end
