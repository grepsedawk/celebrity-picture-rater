# frozen_string_literal: true

class AddCascadingDeleteToVotesForeignKeys < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :votes, column: :left_picture_id
    remove_foreign_key :votes, column: :right_picture_id

    add_foreign_key :votes, :pictures, column: :left_picture_id,
                    on_delete: :cascade
    add_foreign_key :votes, :pictures, column: :right_picture_id, 
                    on_delete: :cascade
  end
end
