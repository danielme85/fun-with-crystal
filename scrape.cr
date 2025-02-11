require "http/client"
require "http/headers"
require "myhtml"
require "sqlite3"

url = "bush-daisy-tellurium.glitch.me"

puts "Loading webpage..."

headers = HTTP::Headers.new 
headers.add("Referer", "https://"+url+"/")

client = HTTP::Client.new url  

loop do
  runScrape(client, headers)
  sleep 60.seconds
end


def runScrape (client, headers)
  results = [] of Item
  response = client.get "/", headers
  if response.body
    html = Myhtml::Parser.new(response.body)
    names = html.css(".content h3").map(&.inner_text).to_a
    prices = html.css(".content .price").map(&.inner_text).to_a

    names.each_with_index do |name, index|
      price = prices[index]
      item = Item.new(name, price)
      results.push(item)
      puts "Found #{name} - #{price}"
    end

  else 
    puts "could not load website"
  end


  if results.any? 
    DB.open "sqlite3://./data.db" do |db|
      results.each do |item|
        #only look for the one bike
        if (item.name === "AW SuperFast Roadster")
          db.exec "insert into bikes values (?, ?, ?)", item.name, item.price, Time.local
          puts "Added item -> #{item.name}"
       end
      end
      puts "Current list in db:"
      db.query "select * from bikes order by datetime desc" do |rs|
        rs.each do 
          puts "#{rs.read(String)} | #{rs.read(String)} | #{rs.read(String)}"
        end
      end
    end
  end
  puts "Waiting for 60 seconds..."
  puts
end


class Item
  def initialize(name : String, price : String)
    @name = name
    @price = price
  end

  def name
    @name
  end

  def price
    @price
  end
end



