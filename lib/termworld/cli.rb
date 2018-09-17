require "termworld"
require "thor"

module Termworld
  class CLI < Thor
    desc "helloworld", "say helloworld"
    def helloworld
      puts `pwd`
    end
  end
end
