class CelebritiesController < ApplicationController
  def index
    @celebrities = Celebrity.all
  end
end
