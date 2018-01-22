# frozen_string_literal: true

class Picture < ApplicationRecord
  belongs_to :celebrity
  has_many :votes, foreign_key: :chosen_picture_id
  has_attached_file :attachment, styles: { voting: '300x', leaderboard: '500x' }
  validates_attachment_content_type :attachment, content_type: %r{\Aimage\/.*\z}

  scope :two_random, -> { order(Arel.sql('RANDOM()')).limit(2) }
  scope :top_ten, lambda {
    joins(<<-SQL
  LEFT JOIN votes ON votes.left_picture_id = pictures.id OR votes.right_picture_id = pictures.id
          SQL
         )
      .where.not(id: 214)
      .group(:id)
      .order(<<-SQL
  SUM(CASE WHEN votes.chosen_picture_id = pictures.id THEN 1 ELSE 0 END) * 1.0 / COUNT(pictures.id) DESC,
  COUNT(votes.id) DESC
  SQL
            )
      .limit(10)
  }
end
