#!/usr/bin/env ruby
raise "usage: resemblance_over.rb N" unless ARGV.length==1
lower_bound = ARGV.first.to_f
STDIN.each do |line|
  res = line.split("\t").first.to_f
  next unless res >= lower_bound
  puts line
end
  
