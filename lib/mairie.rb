
require 'rspec'
require 'nokogiri'
require 'open-uri'


def find_villages_names(page)
  # récup les noms des villages
  villages_names = page.xpath("//a[contains(@class, 'lientxt')]/text()").map {|x| x.to_s.downcase.gsub(" ", "-")}
  return villages_names
end

def find_village_html(page, villages_names)
  # récup leur html et l'associer dans un hash tel que |key = nom, value = morveau html|
  html_villages = page.xpath('//p/a/@href').to_s.split("./").drop(1)
  names_url_hash = Hash[villages_names.zip html_villages]
  return names_url_hash
end

def find_villages_email(page, hash)
  village_email_array = []
  # pour chaque él du HASH, on va chercher l'email = value permet d'aller sur la page du patelin / key va devoir être assocée à l'email dans un nouveau hash
  hash.each {|key, value| 
  page = Nokogiri::HTML(URI.open("https://www.annuaire-des-mairies.com/#{value}"))
  village_email = page.xpath('/html/body/div/main[@class="page-content"]/section[2]/div[@class="container"]/table[@class="table table-striped table-mobile mobile-primary round-small"]/tbody/tr[4]/td[2]').text
  village_email_array.push village_email
}
return village_email_array
end

def hash_villages_email(villages_names, village_email_array)
  names_email_hash = Hash[villages_names.zip(village_email_array)]
  return names_email_hash.map {|a, b| "#{a.rjust(20)} ===> #{b}"}
end

def last(names_email_hash)
  return names_email_hash
end


def perform()
  #Ouvrir la page d'accueil avec le nom de toutes les villes
  page = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))
  villages_names = find_villages_names(page)
  names_url_hash = find_village_html(page, villages_names)
  village_email_array = find_villages_email(page, names_url_hash)
  names_email_hash = hash_villages_email(villages_names, village_email_array)
   puts names_email_hash
   names_email_hash = last(names_email_hash)
end
perform


