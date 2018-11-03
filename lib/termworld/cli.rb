require "termworld"
require "thor"
require "sqlite3"

module Termworld
  class CLI < Thor

    desc "plant", "Plant seed"
    def plant
      init
      if @user[:seeds] <= 0
        twputs "No seeds..."
        return
      end
      @db.execute("insert into plants (growth, user_id) values (0, ?)", @user[:id])
      @db.execute("update users set seeds = seeds - 1 where id = ?", @user[:id])
      twputs "Planted!"
    end

    desc "harvest", "Harvest all grown plants"
    def harvest
      init
      grown_plants_num = @db.execute(
        "select count(*) from plants where user_id = ? and growth >= ?", @user[:id], 30
      )[0][0]
      if grown_plants_num == 0
        twputs "No grown plants..."
        return
      end
      @db.execute("delete from plants where user_id = ? and growth >= ?", @user[:id], 30)
      earning_money = 10 * grown_plants_num
      @db.execute(
        "update users set money = money + ? where id = ?", earning_money, @user[:id]
      )
      twputs "Harvested #{green(grown_plants_num.to_s + " plants")}!"
      twputs "and You have earned #{green(earning_money.to_s + " money")}!"
    end

    desc "buy", "Buy seed"
    def buy
      init
      seed_price = 5
      unless @user[:money] >= seed_price
        twputs "Not enough money..."
        twputs "Price of seed is #{seed_price} money"
      end
      @db.execute(
        "update users set money = money - #{seed_price}, seeds = seeds + 1 where id = ?",
        @user[:id]
      )
      twputs "You have bought seed!"
    end

    desc "check", "Check plants status"
    def check
      init
      first = true
      exist_plants = false
      @db.execute("select id, growth from plants where user_id = ?", @user[:id]).each do |row|
        o = "plant: #{row[1]}/30"
        o.concat(" " + green("harvestable!")) if row[1] == 30
        if first
          exist_plants = true
          first = false
          twputs o
        else
          tweputs o
        end
      end
      unless exist_plants
        twputs "No plants..."
      end
    end

    desc "status", "Show user status"
    def status
      init
      twputs "#User"
      twputs "  seeds: #{@user[:seeds]}"
      twputs "  money: #{@user[:money]}"
      twputs "#Farming"

      home_directory = Setup.class_eval("@@home_directory")
      farming_pid_file = Setup.class_eval("@@farming_pid_file")
      pid_path = "#{Dir::home}/#{home_directory}/#{farming_pid_file}"
      farming_status = File.exists?(pid_path) ? green("Working!") : "Not working..."
      twputs "  #{farming_status}"
    end

    desc "farming", "Farming"
    def farming
      init(true)
      Signal.trap(:INT)  {@killed = true}
      Signal.trap(:TERM) {@killed = true}
      loop do
        @db.execute("update plants set growth = growth + 1 where growth < 30")
        sleep 0.5
        break if @killed
      end
    end

    desc "stop", "Stop farming"
    def stop
      home_directory = Setup.class_eval("@@home_directory")
      farming_pid_file = Setup.class_eval("@@farming_pid_file")
      pid_path = "#{Dir::home}/#{home_directory}/#{farming_pid_file}"
      unless File.exists?(pid_path)
        twputs "Farming not working..."
        return
      end
      `kill $(cat #{pid_path})`
      `rm #{pid_path}`
      twputs "Stopped farming!"
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
