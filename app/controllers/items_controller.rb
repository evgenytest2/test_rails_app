class ItemsController < ApplicationController
  def index
    @items = Item.search(params[:search]).page params[:page]
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
end
