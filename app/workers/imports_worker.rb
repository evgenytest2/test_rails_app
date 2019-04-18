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
      doc = Nokogiri::XML(open(xml_url), nil, 'UTF-8')
      doc.xpath('//offer').each do |el|
        offer_name = el.css('name').text
        offer_model = el.css('model').text
        if offer_name == "" && offer_model == ""
          offer_name = el.css('url').text.gsub(/\/\?r1=yandextr2=/,"").split("/").last.split(".").first.gsub(/_/," ")
        elsif offer_name == "" && offer_model != ""
          offer_name = offer_model
        end
        pictures = el.css('picture').map { |pic| pic.text }
        unless Item.exists?(name: offer_name)
          item = Item.create(
              name: offer_name,
              source_url: el.css('url').text,
              price: el.css('price').text,
              description: el.css('description').text,
              age: el.css('age').text,
              vendor: el.css('vendor').text,
              model: offer_model,
            )
          pictures.each do |pic_url|
            Picture.create(
                url: pic_url,
                item_id: item.id
              )
          end
        end
      end
    end
    urls_array.each {|url| shop_items_array(url)}
  end
end