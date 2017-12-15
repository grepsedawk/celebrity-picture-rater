require 'rails_helper'

RSpec.describe 'Visitor visits root route', type: :system do
  scenario 'Visitor visits /', js: true do
    visit '/'
    expect(current_path).to eq '/celebrities'
  end
end
