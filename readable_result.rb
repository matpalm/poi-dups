#!/usr/bin/env ruby

raise "usage: readable_result.rb pois.uniq.tsv connected_components.out" unless ARGV.length==2

pid_to_name = {}
File.readlines('pois.uniq.tsv').each do |line|
  pid,name = line.split("\t")
  pid_to_name[pid] = name
end

File.readlines('connected_components.out').each do |line|
  cols = line.chomp.split("\t")
  res = cols.shift
  puts res
  cols.each do |pid|
    printf "%07s %s\n", pid, pid_to_name[pid]
  end
  puts
end


