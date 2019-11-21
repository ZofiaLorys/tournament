# frozen_string_literal: true

class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.string :phase
      t.integer :rounds_left_play_off

      t.timestamps
    end
  end
end
