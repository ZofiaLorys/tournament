class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :matches, :rounds_left_play_off, :rounds_left_playoff
  end
end
