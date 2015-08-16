class Image < ActiveRecord::Base
  has_many :modification_requests, as: :modifiable,
    class_name: 'Pixelz::ModificationRequest'
end
