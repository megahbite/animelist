# frozen_string_literal: true

class CreateUserScores < ActiveRecord::Migration[5.0]
  def change
    create_table :user_scores do |t|
      t.references :user, index: true, foreign_key: true
      t.references :anime, index: true, foreign_key: true
      t.integer :status
      t.integer :watched
      t.integer :score

      t.timestamps
    end
  end
end
