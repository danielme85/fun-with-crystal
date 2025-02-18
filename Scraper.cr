require "myhtml"
require "./Item.cr"

def webScraper
  url = "bush-daisy-tellurium.glitch.me"
  headers = HTTP::Headers.new
  headers.add("Referer", "https://" + url + "/")
  client = HTTP::Client.new url

  results = [] of Item
  response = client.get "/", headers
  if response.body
    html = Myhtml::Parser.new(response.body)
    names = html.css(".content h3").map(&.inner_text).to_a
    prices = html.css(".content .price").map(&.inner_text).to_a

    names.each_with_index do |name, index|
      price = prices[index]
      item = Item.new(name, price, Time.local)
      results.push(item)
    end
  else
    puts "could not load website"
  end

  return results
end