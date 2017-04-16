class CreateRedditScores < ActiveRecord::Migration[5.0]
  def change
    create_table :reddit_scores do |t|
      t.references :anime, foreign_key: true
      t.float :socre
      t.integer :rank
      t.integer :week

      t.timestamps
    end
  end
end
