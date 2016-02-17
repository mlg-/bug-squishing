require 'pry'
require 'pry-byebug'

class SomeClass

  def initialize(thing, another_thing)
    @thing = thing
    @another_thing = another_thing
  end

  def some_method
    @thing + 4
  end

  def something
    @something = something
  end

  def self.infinite_loop
    while true
      puts "I AM INFINITE! Well, until the system runs out of memory"
      infinite_loop
    end
  end
end


