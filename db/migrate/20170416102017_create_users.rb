# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :reddit_name
      t.string :mal_name

      t.timestamps
    end
  end
end
