# frozen_string_literal: true

FactoryBot.define do
  factory :picture do
    celebrity
    attachment do
      File.open(
        Dir.glob(
          Rails.root.join('spec/files/taylor_swift/*.png')
        ).sample
      )
    end
  end
end
