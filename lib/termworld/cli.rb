require "termworld"
require "thor"
require "sqlite3"

module Termworld
  class CLI < Thor

    desc "plant", "Plang seed"
    def plant
      init
      if @user[:seeds] <= 0
        puts "No seeds..."
        return
      end
      @db.execute("insert into plants (growth, user_id) values (0, ?)", @user[:id])
      @db.execute("update users set seeds = seeds - 1 where id = ?", @user[:id])
      puts "Planted!"
    end

    desc "farming", "Farming"
    def farming
      init
      Signal.trap(:INT)  {@killed = true}
      Signal.trap(:TERM) {@killed = true}
      loop do
        @db.execute("update plants set growth = growth + 1 where growth < 30")
        puts "growing..."

        6.times do
          break if @killed
          sleep 0.5
        end
        break if @killed
      end
      puts "\033[2K\rStopped growing"
    end

    no_commands do
      def init
        @setup = Setup.new
        @user = @setup.get_user
        @db = @setup.get_db
      end
    end
  end
end
