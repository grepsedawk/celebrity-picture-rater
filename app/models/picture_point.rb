# frozen_string_literal: true

class PicturePoint < ApplicationRecord
  belongs_to :celebrity
  belongs_to :winning_picture, class_name: 'Picture'

  private

  def read_only?
    true
  end
end
