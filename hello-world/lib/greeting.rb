require 'pry'
require 'pry-byebug'

class Greeting

  def initialize
    @user = nil
  end

  def hello_world
    binding.pry
    "Hello World"
  end
end

# puts hello_word
