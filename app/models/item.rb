class Item < ApplicationRecord
  has_many :pictures

  def self.search(search)
    if search && search != ""
      where('lower(name) LIKE lower(:search) OR lower(description) LIKE lower(:search)', search: "%#{search}%")
    else
      all
    end
  end

  class << self
    def basic_method_with_transaction(items)
      transaction do
        create items
        #import([:name, :source_url, :price, :description, :age, :vendor, :model], items)
      end
    end
  end

end
