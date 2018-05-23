# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Picture, type: :model do
  let(:celebrity) { FactoryBot.create(:celebrity, name: 'Taylor Swift') }

  it 'can be deleted when it has votes' do
    FactoryBot.create_list(:picture, 2, celebrity: celebrity)
    left = Picture.first
    right = Picture.last
    vote = Vote.new

    vote.celebrity = celebrity
    vote.left_picture_id = left.id
    vote.right_picture_id = right.id
    vote.chosen_picture_id = left.id
    vote.save!

    expect { left.destroy }.not_to raise_error
    expect(Picture.count).to eq 1
  end
end
