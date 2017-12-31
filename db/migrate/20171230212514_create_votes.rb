# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes, id: :uuid do |t|
      t.references :left_picture, foreign_key: { to_table: :pictures }
      t.references :right_picture, foreign_key: { to_table: :pictures }
      t.references :chosen_picture, foreign_key: { to_table: :pictures }

      t.timestamps
    end
  end
end
