class CreateLists < ActiveRecord::Migration[7.0]
  def change
    create_table :lists do |t|
      t.text :description
      t.text :description_fr
      t.text :description_en
      t.text :description_es
      t.text :description_ar
      t.text :description_nb
      t.string :name
      t.string :name_fr
      t.string :name_en
      t.string :name_es
      t.string :name_ar
      t.string :name_nb
      t.boolean :public
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
