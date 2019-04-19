class ImportsWorker
  include Sidekiq::Worker

  def perform
    require 'open-uri'

    urls_array = [
      'http://static.ozone.ru/multimedia/yml/facet/div_soft.xml',
      'http://www.trenazhery.ru/market2.xml',
      'http://www.radio-liga.ru/yml.php',
      'http://armprodukt.ru/bitrix/catalog_export/yandex.php'
    ]

    def shop_items_array(xml_url)
      result_array = []
      doc = Nokogiri::XML(open(xml_url), nil, 'UTF-8')
      doc.xpath('//offer').each do |el|
        #puts el
        offer_name = el.css('name').text
        offer_model = el.css('model').text
        if offer_name == "" && offer_model == ""
          offer_name = el.css('url').text.gsub(/\/\?r1=yandextr2=/,"").split("/").last.split(".").first.gsub(/_/," ")
        elsif offer_name == "" && offer_model != ""
          offer_name = offer_model
        end
        offer_hash = {
          name: offer_name,
          source_url: el.css('url').text,
          price: el.css('price').text,
          description: el.css('description').text,
          age: el.css('age').text,
          vendor: el.css('vendor').text,
          model: offer_model,
          pictures: el.css('picture').map { |pic| pic.text }.join(',').to_s
        }
        #puts offer_hash
        result_array << offer_hash
      end
      return result_array
    end

    def all_items(urls_array)
      result_array = []
      urls_array.each {|url| result_array += shop_items_array(url)}
      return result_array
    end
    
    def create_db_items_array
      t1 = Time.now
      result_array = []
      Item.all.each do |i|
        item_hash = {
          name: i[:name],
          source_url: i[:source_url],
          price: i[:price],
          description: i[:description],
          age: i[:age],
          vendor: i[:vendor],
          model: i[:model],
          pictures: i[:pictures]
        }
        result_array << item_hash
      end
      t2 = Time.now
      puts "------create_existing_names_array TIME #{t2-t1}"
      result_array
    end

    def create_array_for_upload(array_from_db, array_from_internet)
      array_from_internet - array_from_db
    end
    
    array_for_upload = create_array_for_upload(create_db_items_array, all_items(urls_array))
    puts array_for_upload.first
    Item.basic_method_with_transaction(array_for_upload)
   

  end
end