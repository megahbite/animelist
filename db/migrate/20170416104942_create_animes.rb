# frozen_string_literal: true

class CreateAnimes < ActiveRecord::Migration[5.0]
  def change
    create_table :animes do |t|
      t.string :title
      t.text :image_url
      t.integer :episode_count
      t.integer :mal_id, index: true
      t.text :synonyms

      t.timestamps
    end
  end
end
