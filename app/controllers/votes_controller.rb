# frozen_string_literal: true

class VotesController < ApplicationController
  def new
    celebrity = Celebrity.find(params[:celebrity_id])
    count = Integer(params.fetch(:count, 1))
    votes = celebrity.build_votes(count: count)

    render json: {
      votes: votes
    }
  end

  def left
    vote = Vote.find(params[:id])
    vote.chosen_picture_id = vote.left_picture_id
    vote.save!

    render json: { choice: :left }
  end

  def right
    vote = Vote.find(params[:id])
    vote.chosen_picture_id = vote.right_picture_id
    vote.save!

    render json: { choice: :right }
  end
end
