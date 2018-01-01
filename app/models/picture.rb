# frozen_string_literal: true

class Picture < ApplicationRecord
  belongs_to :celebrity
  has_attached_file :attachment, styles: { voting: '300x' }
  validates_attachment_content_type :attachment, content_type: %r{\Aimage\/.*\z}

  scope :two_random, -> { order(Arel.sql('RANDOM()')).limit(2) }
end
