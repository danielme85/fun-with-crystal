require "http/client"
require "http/headers"
require "sqlite3"
require "./Scraper.cr"

loop do
  runScrape()
  sleep 60.seconds
end

def runScrape()
  results = webScraper()
  if results.any?
    DB.open "sqlite3://./data.db" do |db|
      results.each do |item|
        # only look for the one bike
        if (item.name === "AW SuperFast Roadster")
          db.exec "insert into bikes values (?, ?, ?)", item.name, item.price, item.datetime
          puts "Added item -> #{item.name}"
        end
      end
      puts "Last 10 scrapes: "
      db.query "select * from bikes order by datetime desc limit 10" do |rs|
        rs.each do
          puts "#{rs.read(String)} | #{rs.read(String)} | #{rs.read(String)}"
        end
      end
    end
  end
  puts "Waiting for 60 seconds..."
  puts
end

