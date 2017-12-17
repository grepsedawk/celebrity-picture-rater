require 'rails_helper'

RSpec.describe 'Visitor visits root route' do
  let(:celebrity) { FactoryBot.create(:celebrity, name: 'Taylor Swift') }

  before do
    FactoryBot.create(:picture, celebrity: celebrity)
    visit celebrity_path(celebrity)
  end

  it "displays celebrity's name" do
    expect(page.body).to include(celebrity.name)
  end

  it 'displays celebrity picture count' do
    expect(page.body).to include("#{celebrity.pictures.count} pictures")
  end
end
