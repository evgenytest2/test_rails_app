class Item < ApplicationRecord
  has_many :pictures

  def self.search(search)
    if search && search != ""
      where('lower(name) LIKE lower(:search) OR lower(description) LIKE lower(:search)', search: "%#{search}%")
    else
      all
    end
  end

end
