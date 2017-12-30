# frozen_string_literal: true

class VotesController < ApplicationController
  def new
    celebrity = Celebrity.find(params[:celebrity_id])
    vote = celebrity.build_vote

    json = {
      celebrity_id: celebrity.id,
      uuid: vote.id,
      left_picture_path: vote.left_picture.attachment.url,
      right_picture_path: vote.right_picture.attachment.url
    }

    render json: json
  end

  def left
    vote = Vote.find(params[:id])
    vote.chosen_picture_id = vote.left_picture_id
    vote.save!
    redirect_to new_celebrity_vote_path(params[:celebrity_id])
  end

  def right
    vote = Vote.find(params[:id])
    vote.chosen_picture_id = vote.right_picture_id
    vote.save!
    redirect_to new_celebrity_vote_path(params[:celebrity_id])
  end
end
