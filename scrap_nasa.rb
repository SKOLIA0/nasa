require "net/http"
require "json"
require "nokogiri"
require "open-uri"

url = "https://www.nasa.gov/press-release/nasa-industry-to-collaborate-on-space-communications-by-2025"
doc =  Nokogiri::XML(URI.open(url))
path = (doc.element_children.xpath("//script"))[4].text.strip.gsub("window.forcedRoute = ", "").gsub( /["]/, '')
next_url = "https://www.nasa.gov/api/2" + path
next_uri = URI(next_url)
next_response = Net::HTTP.get(next_uri)
data = JSON.parse(next_response)
data_source = data["_source"]
title = data["_source"]["title"]
data_body = data_source["body"]
doc = Nokogiri::HTML(data_body)
release_no = data_source["release-id"]
date = DateTime.parse(data_source["promo-date-time"]).strftime("%F")
article = doc.xpath("//p").text.gsub("-end-", "")
hash = {
  :title => title,
  :date => date,
  :release_no => release_no,
  :article => article
}
puts hash
