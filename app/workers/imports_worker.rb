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
      doc = Nokogiri::XML(open("http://armprodukt.ru/bitrix/catalog_export/yandex.php"), nil, 'UTF-8')
      doc.xpath('//offer').each do |el|
        offer_name = el.css('name').text
        offer_name == "" if offer_name = el.css('model').text 
        offer_hash = {
          name: offer_name,
          url: el.css('url').text,
          price: el.css('price').text,
          description: el.css('description').text,
          age: el.css('age').text,
          vendor: el.css('vendor').text,
          model: el.css('model').text,
          pictures: el.css('picture').map { |pic| pic.text }
        }
        puts offer_hash
        result_array << offer_hash
      end
      return result_array
    end

    def all_items(urls_array)
      result_array = []
      urls_array.each {|url| result_array += shop_items_array(url)}
      return result_array
    end

    all_items(urls_array).each do |i|
      unless Item.exists?(name: i[:name])
        item = Item.create(
            name: i[:name],
            source_url: i[:url],
            price: i[:price],
            description: i[:description],
            age: i[:age],
            vendor: i[:vendor],
            model: i[:model]
          )
        i[:pictures].each do |pic_url|
          Picture.create(
              url: pic_url,
              item_id: item.id
            )
        end
      end
    end

  end
end