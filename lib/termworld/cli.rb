require "termworld"
require "thor"

module Termworld
  class CLI < Thor
    desc "For test"
    def helloworld
      puts `pwd`
    end
  end
end
