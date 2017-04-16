class CreateMalScores < ActiveRecord::Migration[5.0]
  def change
    create_table :mal_scores do |t|
      t.references :anime, foreign_key: true
      t.float :score
      t.integer :rank
      t.integer :week

      t.timestamps
      t.index [:anime_id, :week]
    end
  end
end
