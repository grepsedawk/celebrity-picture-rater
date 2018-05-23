# frozen_string_literal: true

class Picture < ApplicationRecord
  belongs_to :celebrity
  has_one :picture_point, foreign_key: :winning_picture_id
  has_many :votes, foreign_key: :chosen_picture_id, dependent: :destroy
  has_attached_file :attachment, styles: { voting: '300x', leaderboard: '500x' }
  validates_attachment_content_type :attachment, content_type: %r{\Aimage\/.*\z}

  scope :two_random, -> { order(Arel.sql('RANDOM()')).limit(2) }
  scope :top_ten, lambda {
    joins(:picture_point).order('picture_points.points DESC').limit(10)
  }

  def points
    picture_point&.points || 0
  end
end
