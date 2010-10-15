#!/usr/bin/env ruby
require 'csv'
require 'set'

['places.tsv', 'pois.tsv', 'near_dups_v2.out','connected_components.out'].each do |file| 
  raise "expected #{file}" unless File.exist?(file) 
end

# read place reference data
Place = Struct.new :name, :taxo
places = {}
File.open('places.tsv').each do |line|
  next if line =~ /^id/
  id, name, taxo = line.chomp.split("\t")
  places[id] = Place.new name, taxo
end

# read poi reference data
Poi = Struct.new :id, :name, :place
pois = {}
File.open('pois.tsv').each do |line|
  next if line =~ /^poi_id/
  poi_id, name, type, place_id = line.chomp.split("\t")
  raise "wtF? #{place_id}" unless places[place_id]
  pois[poi_id] = Poi.new poi_id, name, places[place_id]
end

# read mapping from poi_id to connected component group
poi_to_group = {}
File.open('connected_components.out').each do |line|
  group, poi_id = line.chomp.split("\t")
  poi_to_group[poi_id] = group
end

output = File.open('result.csv','w')
CSV::Writer.generate(output) do |csv|

  csv << ['resemblance','place name','place taxo','group','merge link',
          'poi1 id','poi1 name','poi2 id','poi2 name']

  File.open('near_dups_v2.out').each do |line|
    cols = line.chomp.split("\t")
    resemblance = cols.shift
    poi1, poi2 = cols.map{ |id| pois[id] }

    output_row = []
    output_row << sprintf("%0.3f", resemblance)

    place = poi1.place
    raise "expected to be in same place? #{line}" unless place == poi2.place
    output_row << place.name << place.taxo
    
    group = poi_to_group[poi1.id]
    raise "expected pois to be in same connected component group" unless group == poi_to_group[poi2.id]
    output_row << group
    
    output_row << "http://atlas.lonelyplanet.com/ui/merge_pois/new?ids[]=#{poi1.id}&ids[]=#{poi2.id}"
    
    output_row << poi1.id << poi1.name
    output_row << poi2.id << poi2.name

    csv << output_row
  end
end
output.close




