require 'sinatra'
require 'pry'
require 'pry-byebug'

get '/' do
  @cute_animals = ["kittens", "koalas", "tree frogs"]
  erb :index
end

def some_method
  puts "something"
end
