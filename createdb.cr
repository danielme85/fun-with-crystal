require "sqlite3"

DB.open "sqlite3://./data.db" do |db|
  db.exec "create table bikes (name text, price text, datetime default current_timestamp)"

  puts "Created table..."
end
