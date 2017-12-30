# frozen_string_literal: true

class Celebrity < ApplicationRecord
  has_many :pictures
  has_many :votes

  def to_s
    "#{name} (#{pictures.count} pictures)"
  end

  def build_vote(params = nil)
    Vote.build(params, celebrity: self)
  end
end
