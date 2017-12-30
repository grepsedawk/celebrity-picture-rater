# frozen_string_literal: true

class Picture < ApplicationRecord
  belongs_to :celebrity
  has_attached_file :attachment
  validates_attachment_content_type :attachment, content_type: %r{\Aimage\/.*\z}
end
