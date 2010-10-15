#!/usr/bin/env ruby
STDIN.each do |line|
  cols = line.chomp.split("\t")
  ids = []
  while (!cols.empty?) do
    id,name = cols.slice!(0,2)
    ids << id.to_i
  end
  ids.sort!
  while ids.size >= 2
    first = ids.shift
    ids.each do |second|
      puts "#{first}\t#{second}"
    end
  end
end
