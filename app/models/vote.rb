# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :celebrity
  belongs_to :left_picture, class_name: 'Picture'
  belongs_to :right_picture, class_name: 'Picture'
  belongs_to :chosen_picture, class_name: 'Picture', required: false

  def self.build(params, celebrity:)
    new(
      *params,
      celebrity: celebrity
    ).tap do |vote|
      vote.left_picture, vote.right_picture = celebrity.pictures.two_random
      vote.save!
    end
  end
end
