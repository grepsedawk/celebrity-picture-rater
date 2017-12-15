require 'rails_helper'

RSpec.describe 'Visitor visits root route' do
  let!(:celebrity) { FactoryBot.create(:celebrity, name: 'Taylor Swift') }

  it "displays celebrity's name" do
    visit celebrity_path(celebrity)

    expect(page.body).to include(celebrity.name)
  end
end
