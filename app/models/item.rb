class Item < ApplicationRecord


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
      end
    end
  end

end
