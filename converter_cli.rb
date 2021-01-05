#!/usr/bin/env ruby

require 'readline'
require './converter'

puts '-----------------------------------------'
puts 'Merchants converter to the galaxy'
puts 'Type \'exit\' to exit the converter program'
puts '-----------------------------------------'

converter = Converter.new

while buf = Readline.readline('> ', true)
  break if buf == "exit"
  puts converter.parse(buf)
end
