require 'rails_helper'

RSpec.describe 'Photo Uploads' do
  let(:celebrity) { FactoryBot.create(:celebrity, name: 'Taylor Swift') }

  scenario 'visitor uploads picture', js: true do
    picture_count = Picture.count
    visit celebrity_path(celebrity)

    click_on I18n.t('pictures.upload')
    drop_in_dropzone(Rails.root.join('spec/files/taylor_swift/red_shorts.png'))

    expect(Picture.count).to eq picture_count + 1
  end
end

def drop_in_dropzone(file_path)
  page.execute_script <<-JS
    hiddenFileUpload = document.querySelector('.dz-hidden-input')
    hiddenFileUpload.removeAttribute('style')
    hiddenFileUpload.setAttribute('name', 'hiddenFileUploader')
  JS
  attach_file('hiddenFileUploader', file_path)
  find('.dz-success', match: :first)
end
