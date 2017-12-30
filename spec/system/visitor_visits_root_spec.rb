# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Visitor visits root route' do
  it 'redirects to /celebrities' do
    visit '/'

    expect(current_path).to eq '/celebrities'
  end
end
