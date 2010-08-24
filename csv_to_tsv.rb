#!/usr/bin/env ruby
require 'csv'
STDIN.each do |line|
  next if line =~ /^poi_id/
  puts CSV.parse_line(line.gsub("\t",' ')).join("\t")
end
