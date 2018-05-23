# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Picture, type: :model do
  let(:celebrity) { FactoryBot.create(:celebrity, name: 'Taylor Swift') }

  it 'can be deleted when it has votes' do
    FactoryBot.create_list(:picture, 1, celebrity: celebrity)
    picture = Picture.first
    vote = Vote.new

    vote.celebrity = celebrity
    vote.left_picture_id = picture.id
    vote.right_picture_id = picture.id
    vote.chosen_picture_id = picture.id
    vote.save!

    expect { picture.destroy }.not_to raise_error
    expect(Picture.count).to eq 0
  end
end
