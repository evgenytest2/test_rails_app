class Picture < ApplicationRecord
  belongs_to :contact, optional: true
end
