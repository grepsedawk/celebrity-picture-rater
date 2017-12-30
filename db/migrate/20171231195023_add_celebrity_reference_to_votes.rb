# frozen_string_literal: true

class AddCelebrityReferenceToVotes < ActiveRecord::Migration[5.2]
  def change
    add_reference :votes, :celebrity, foreign_key: true
  end
end
