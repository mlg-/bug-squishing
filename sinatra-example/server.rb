require 'sinatra'
require 'pry'
require 'pry-byebug'

get '/' do
  binding.pry
  @cute_animals = ["kittens", "koalas", "tree frogs"]
  erb :index
end
