#!/usr/bin/env ruby
require 'csv'
STDIN.each do |line|
  next if line =~ /^poi_id/
  line.gsub "\t",' '
  #puts CSV.parse_line(line).join("\t")
  cols = CSV.parse_line(line)
  puts [0,1,3].map{|i| cols[i]}.join("\t")
end
