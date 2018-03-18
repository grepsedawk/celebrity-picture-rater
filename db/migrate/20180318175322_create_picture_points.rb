# frozen_string_literal: true

class CreatePicturePoints < ActiveRecord::Migration[5.2]
  def change
    create_view :picture_points
  end
end
