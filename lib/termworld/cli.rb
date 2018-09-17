require "termworld"
require "thor"
require "sqlite3"

require "./setup"

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
        @db ||= SQLite3::Database.new(@@database)
        @user = Setup.init(@db)
      end
    end
  end
end
