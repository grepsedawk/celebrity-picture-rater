# frozen_string_literal: true

class Picture < ApplicationRecord
  belongs_to :celebrity
  has_many :votes, foreign_key: :chosen_picture_id
  has_attached_file :attachment, styles: { voting: '300x', leaderboard: '500x' }
  validates_attachment_content_type :attachment, content_type: %r{\Aimage\/.*\z}

  scope :two_random, -> { order(Arel.sql('RANDOM()')).limit(2) }
  scope :top_ten, lambda {
    joins(:votes).group(:id)
                 .order('COUNT(votes.id) DESC')
                 .limit(10)
  }
end
