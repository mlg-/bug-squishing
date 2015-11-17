require_relative '../lib/greeting'

RSpec.describe Greeting do
  it 'should say hello world' do
    greeting = Greeting.new
    expect(greeting.hello_world).to eq("Hello World")
  end
end
