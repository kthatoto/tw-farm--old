require "termworld"
require "thor"
require "sqlite3"

module Termworld
  class CLI < Thor

    desc "plant", "Plang seed"
    def plant
      init
      puts "Planted!"
    end

    desc "farming", "Farming"
    def farming
      init
      loop do
        sleep 1
      end
    end

    no_commands do
      def init
        Dir::chdir(Dir::home)
        unless Dir::exists?(".termworld")
          Dir::mkdir(".termworld")
        end
        Dir::chdir(".termworld")
        db = SQLite3::Database.new "termworld.db"
        tables = [
          "create table users (\n  id integer primary key\n);",
          "create table plants (\n" +
          "  id integer primary key,\n" +
          "  growth integer default 0\n" +
          ");",
        ]
        tables.each do |table|
          table_name = table.split(" ")[2]
          current_schema = `sqlite3 termworld.db '.schema #{table_name}'`
          pp current_schema.empty?
          # db.execute(table)
        end
      end
    end
  end
end
