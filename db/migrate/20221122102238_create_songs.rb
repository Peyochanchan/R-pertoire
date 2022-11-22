class CreateSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :songs do |t|
      t.text :lyrics
      t.text :lyrics_fr
      t.text :lyrics_en
      t.text :lyrics_es
      t.text :lyrics_ar
      t.text :lyrics_nb
      t.string :composer
      t.string :title
      t.string :title_fr
      t.string :title_en
      t.string :title_es
      t.string :title_ar
      t.string :title_nb
      t.boolean :public
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
