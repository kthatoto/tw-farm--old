require "termworld"
require "thor"

module Termworld
  class CLI < Thor
    def helloworld
      puts `pwd`
    end
  end
end
