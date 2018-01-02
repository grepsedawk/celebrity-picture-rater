# frozen_string_literal: true

class PicturesController < ApplicationController
  def new
    @celebrity = Celebrity.find(params[:celebrity_id])
    @picture = @celebrity.pictures.new
  end

  def create
    @celebrity = Celebrity.find(params[:celebrity_id])
    @celebrity.pictures.create!(attachment: params[:file])
  end

  def index
    @celebrity = Celebrity.find(params[:celebrity_id])
    @pictures = @celebrity.pictures.top_ten
  end
end
