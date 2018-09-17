require "termworld"
require "thor"

module Termworld
  class CLI < Thor

    desc "plant", "Plang seed"
    def plant
      init
      puts "Planted!!"
    end

    no_commands do
      def init
        Dir::chdir(Dir::home)
        unless Dir::exists?(".termworld")
          Dir::mkdir(".termworld")
        end
      end
    end
  end
end
