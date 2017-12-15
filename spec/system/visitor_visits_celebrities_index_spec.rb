require 'rails_helper'

RSpec.describe 'Visitor visits root route' do
  let!(:celebrities) { FactoryBot.create_list(:celebrity, 3) }

  it 'displays all celebrities' do
    visit '/celebrities'

    celeb_names = celebrities.pluck(:name)

    expect(page.body).to include(*celeb_names)
  end
end
