require "http/server"
require "crinja"
require "sqlite3"
require "json"
require "./Scraper.cr"

env = Crinja.new
env.loader = Crinja::Loader::FileSystemLoader.new("views/")

server = HTTP::Server.new do |context|
  path = context.request.path

  if (path === "/")
    results = [] of {name: String, price: String, time: Time}
    DB.open "sqlite3://./data.db" do |db|
      db.query "select * from bikes order by datetime desc" do |rs|
        rs.each do
          results << {
            name:  rs.read(String),
            price: rs.read(String),
            time:  rs.read(Time),
          }
        end
      end
    end

    context.response.content_type = "text/html"
    template = env.get_template("index.html")
    context.response.puts(template.render({"results" => results.to_json}))
  end

  if (path === "/scrape")
      output = [] of String
      results = webScraper()
      if results.any?
        DB.open "sqlite3://./data.db" do |db|
        results.each do |item|
          # only look for the one bike
          if (item.name === "AW SuperFast Roadster")
            db.exec "insert into bikes values (?, ?, ?)", item.name, item.price, item.datetime
            output << "Added item -> #{item.name} = #{item.price} @ #{item.datetime}"
          end
        end
      end
    end

    context.response.content_type = "text/plain"
    context.response.print output
  end  

  
end

address = server.bind_tcp 8080
puts "Listening on http://#{address}"
server.listen
