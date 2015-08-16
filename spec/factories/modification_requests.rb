FactoryGirl.define do
  factory :modification_request, class: 'Pixelz::ModificationRequest' do
    modifiable { create(:image) }
  end
end
