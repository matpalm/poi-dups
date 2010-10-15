#!/usr/bin/env ruby
N = 4
files = []
files = (0...N).map{ |n| File.open("pois.p#{n}.out",'w') }
STDIN.each do |line|
  next if line =~ /^poi_id/
  place = line.chomp.split("\t").last
  idx = place.to_i % N
  files[idx].puts line
end
files.each { |f| f.close }
