class ItemsController < ApplicationController
  def index
    @items = Item.search(params[:search]).order(sort_column + ' ' + sort_direction).page params[:page]
  end

  def show
    @item = Item.find(params[:id])
  end

  def import
    @last_item = Item.all.last
  end

  def import_data
    ImportsWorker.perform_async
  end

private
  def sort_column
    params[:sort] || "price"
  end
  
  def sort_direction
    params[:direction] || "asc"
  end
end
