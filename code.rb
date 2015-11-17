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
end
