require "termworld"
require "thor"
require "sqlite3"

module Termworld
  class CLI < Thor

    desc "plant", "Plant seed"
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

    desc "harvest", "Harvest all grown plants"
    def harvest
      init
      grown_plants_num = @db.execute(
        "select count(*) from plants where user_id = ? and growth >= ?", @user[:id], 30
      )[0][0]
      if grown_plants_num == 0
        puts "No grown plants..."
        return
      end
      @db.execute("delete from plants where user_id = ? and growth >= ?", @user[:id], 30)
      earning_money = 10 * grown_plants_num
      @db.execute(
        "update users set money = money + ? where id = ?", earning_money, @user[:id]
      )
      puts "Harvested #{grown_plants_num} plants!"
      puts "and You have earned #{earning_money} money!"
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
      pid_path = "#{Dir::home}/#{home_directory}/#{farming_pid_file}"
      unless File.exists?(pid_path)
        puts "Farming not working..."
        return
      end
      `kill $(cat #{pid_path})`
      `rm #{pid_path}`
      puts "Stopped farming!"
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
