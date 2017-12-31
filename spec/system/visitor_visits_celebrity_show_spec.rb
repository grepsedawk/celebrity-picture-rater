# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Visitor visits root route' do
  let(:celebrity) { FactoryBot.create(:celebrity, name: 'Taylor Swift') }

  before do
    FactoryBot.create_list(:picture, 2, celebrity: celebrity)
    visit celebrity_path(celebrity)
  end

  it "displays celebrity's name", js: true do # js for screenshot
    expect(page.body).to include(celebrity.name)
  end

  it 'displays celebrity picture count' do
    expect(page.body).to include("#{celebrity.pictures.count} pictures")
  end
end
