require'open-uri'
require'nokogiri'

def the_page
  page = Nokogiri::HTML(URI.open("https://coinmarketcap.com/all/views/all/"))
  return page
end

def name(page)
  cryptos_name = page.xpath('/html/body/div/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr/td/div/a')
  cryptos_names_array = cryptos_name.map {|element| element["title"]}.compact.uniq  
  return cryptos_names_array
end

def amouts(page)
  cryptos_amounts_array = page.xpath('/html/body/div/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr[@class="cmc-table-row"]/td[@class="cmc-table__cell cmc-table__cell--sortable cmc-table__cell--right cmc-table__cell--sort-by__price"]/div[@class="sc-131di3y-0 cLgOOr"]/a[@class="cmc-link"]').text.split('$')
  cryptos_amounts_array = cryptos_amounts_array.drop(1)
  return  cryptos_amounts_array
end

def idk(cryptos_amounts_array,cryptos_names_array)
  cryptos_hash = Hash[cryptos_names_array.zip cryptos_amounts_array]
  cryptos_hash_arr = []
  cryptos_hash_arr.push(cryptos_hash)
  puts cryptos_hash.map {|a,b| "#{a.rjust(20)} ===> #{b}$" }
end

def process 
  page = the_page
  cryptos_names_array = name(page)
  cryptos_amounts_array = amouts(page)
  idk(cryptos_amounts_array,cryptos_names_array)
end

process