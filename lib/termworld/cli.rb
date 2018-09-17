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
      init(true)
      Signal.trap(:INT)  {@killed = true}
      Signal.trap(:TERM) {@killed = true}
      loop do
        @db.execute("update plants set growth = growth + 1 where growth < 30")
        sleep 3
        break if @killed
      end
    end

    desc "stop", "Stop farming"
    def stop
      home_directory = Setup.class_eval("@@home_directory")
      farming_pid_file = Setup.class_eval("@@farming_pid_file")
      pid_path = "~/#{home_directory}/#{farming_pid_file}"
      `kill $(cat #{pid_path})`
      `rm #{pid_path}`
    end

    no_commands do
      def init(daemon = false)
        @setup = Setup.new(daemon)
        @user = @setup.get_user
        @db = @setup.get_db
      end
    end
  end
end
