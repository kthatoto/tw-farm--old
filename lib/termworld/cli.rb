require "termworld"
require "thor"

module Termworld
  class CLI < Thor
    def helloworld
      puts "Hello World from Terminal"
    end
  end
end
