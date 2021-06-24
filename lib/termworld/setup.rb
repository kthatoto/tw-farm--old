require "sqlite3"
require "yaml"

class Setup
  @@home_directory = ".termworld"
  @@config_file = "config.yml"
  @@database = "termworld.db"
  @@farming_pid_file = "farming.pid"
  def initialize(daemon = false)
    Dir::chdir(Dir::home)
    unless Dir::exists?(@@home_directory)
      Dir::mkdir(@@home_directory)
    end
    Dir::chdir(@@home_directory)

    if daemon
      if File.exists?(@@farming_pid_file)
        twputs "Already farming..."
        exit
      end
      twputs "Starting farming!"
      Process.daemon(true, true)
      File.open(@@farming_pid_file, "w") {|f| f.puts Process.pid}
    end

    @db ||= SQLite3::Database.new(@@database)
    db_init
    config_init
    get_user
    return {
      user: @user,
      db: @db,
    }
  end

  def get_db
    return @db
  end
  def get_user
    return @user if @user
    user_data = @db.execute("select id, seeds, money from users where id = ?", @user_id)[0]
    @user = {
      id: user_data[0],
      seeds: user_data[1],
      money: user_data[2],
    }
  end
  def config_init
    unless File.exists?(@@config_file)
      File.open(@@config_file, "w") do |f|
        @user_id ||= 1
        f.puts({"user_id" => @user_id}.to_yaml)
      end
    end
    config = YAML.load_file("./#{@@config_file}")
    @user_id ||= config["user_id"]
  end
  def db_init
    tables = [
      "create table users (\n" +
      "  id integer primary key,\n" +
      "  seeds integer default 0,\n" +
      "  money integer default 0\n" +
      ")",

      "create table plants (\n" +
      "  id integer primary key,\n" +
      "  growth integer default 0,\n" +
      "  user_id integer\n" +
      ")",
    ]
    begin
      tables.each do |table|
        table_name = table.split(" ")[2]
        @db.execute(table)
      end
    rescue
    end
    unless @db.execute("select id from users")[0]
      @db.execute("insert into users (id, seeds, money) values (1, 3, 100)")
      @user_id = 1
    end
  end
end
