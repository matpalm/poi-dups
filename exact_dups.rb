#!/usr/bin/env ruby
# cat pois.tsv | ./exact_dups.rb > pois.uniq.tsv 2> exact_dups.out

name_places_to_ids = {}

STDIN.each do |line|
  id,name,place = line.split("\t")
  name_place = "#{name}|#{place}"
  puts line if not name_places_to_ids.has_key? name_place
  name_places_to_ids[name_place] ||= []
  name_places_to_ids[name_place] << id
end

name_places_to_ids.each do |name_place, ids|
  next unless ids.length > 1
  STDERR.puts ids.join(' ')
end


