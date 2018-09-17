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
        tables = <<-SQL
          create table users (id integer primary key);
          create table plants (
            id integer primary key,
            growth integer default 0
          );
        SQL
        db.execute(tables)
      end
    end
  end
end
