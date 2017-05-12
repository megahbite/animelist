class CreateMangas < ActiveRecord::Migration[5.0]
  def change
    create_table :mangas do |t|
      t.integer :mal_id, index: true
      t.string :title
      t.text :image_url
      t.integer :chapter_count
      t.text :synonyms
      t.integer :latest_rank
      t.float :latest_score
      t.integer :latest_mal_rank
      t.float :latest_mal_score

      t.timestamps
    end
  end
end
