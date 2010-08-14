#!/usr/bin/env ruby
require 'csv'
STDIN.each do |line|
  id,name,place = line.split "\t"
  puts name
#  puts [name,place].join("\t")
end
