#!/usr/bin/env ruby
require 'csv'
STDIN.each do |line|
  next if line =~ /^id/
  line.gsub "\t",' '
  id,name,place = CSV.parse_line(line)
  puts [id,name,place].join("\t")
end
