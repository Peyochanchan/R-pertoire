class CreateListSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :list_songs do |t|
      t.integer :position
      t.string :tonality
      t.references :list, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true

      t.timestamps
    end
  end
end
